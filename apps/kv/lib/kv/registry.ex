defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry
  """
  def start_link(opts) do
    # 1.Pass the name to Genserver's init
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Looks up the bucket pid for 'name' stored in 'server'

  Returns '{:ok, pid}' if the bucket exists, ':error" otherwise.
  """
  def lookup(server, name) do
    # 2.Lookup is now done directly, without accessing the server
    case :ets.lookup(server, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end

  end

  @doc """
  Ensures there is a bucket associated with the given 'name' in 'server'.
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  @doc """
  Stops the registry
  """
  def stop(server) do
    GenServer.stops(server)
  end

  ## Server Callbacks

  def init(table) do
    # 3.We hava replaced the names map by the ETS table
    names = :ets.new(table, [:named_table, read_concurrency: true])
    refs = %{}
    {:ok, {names,refs}}

  end

    # 4.The previours handle_call callback for lookup was removed
#  def handle_call({:lookup, name}, _from, {names, _} = state) do
#    {:reply, Map.fetch(names, name), state}
#  end

  def handle_call({:create, name}, _from, {names, refs}) do
    case lookup(names, name) do
      {:ok, pid} ->
        {:reply, pid, {names, refs}}
      :error ->
        {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, pid})
        {:reply, pid, {names, refs}}
    end
  end

  def handle_cast({:create, name}, {names, refs}) do
    # 5.Read and write to the ETS table instead of the map
    case lookup(names, name) do
      {:ok, _pid} ->
        {:noreply, {names, refs}}
      :error ->
        {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, pid})
        {:noreply, {names, refs}}
    end
#    if Map.has_key?(names, name) do
#      {:noreply, {names, refs}}
#    else
#      {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket )
#      ref = Process.monitor(pid)
#      refs = Map.put(refs, ref, name)
#      names = Map.put(names, name, pid)
#      {:noreply, {names, refs}}
##      {:ok, bucket} = KV.Bucket.start_link([])
##      {:noreply, Map.put(names, name, bucket)}
#    end
  end

  def handle_info(:DOWN, ref, :process, _pid, _reason, {names, refs}) do
    # 6.Delete from the ETS table instead of the map
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end