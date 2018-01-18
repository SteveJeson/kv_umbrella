defmodule Efence.Test do
  @moduledoc false
  require Logger
  @timeout 60000

  def start do
    1..20
    |> Enum.map(fn i -> async_call_square_root(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  def dispatch_devicecodes(params) do
    efence_id = params[:code]
    interval = params[:interval]
    String.split(params[:deviceCodes], ",")
                       |> Enum.map(fn i -> async_call_efence_root(efence_id, i, interval) end)
                       |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp async_call_efence_root(efenceId, deviceCode, interval) do
#    Task.async(fn ->
#      :poolboy.transaction(
#        :worker,
#        fn pid -> GenServer.call(pid, {:start, efenceId, deviceCode, interval}) end,
#        @timeout
#      )
#    end)

    Task.Supervisor.async {Efence.RouterTasks, :"a@127.0.0.1"}, fn ->
      :poolboy.transaction(
        :worker,
        fn pid -> GenServer.call(pid, {:start, efenceId, deviceCode, interval}) end,
        @timeout
      )
    end
  end

  defp async_call_square_root(i) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid -> GenServer.call(pid, {:square_root, i}) end,
        @timeout
      )
    end)
  end

  defp await_and_inspect(task), do: task |> Task.await(@timeout) |> IO.inspect()

  def sum(a, b) do
    sum = a + b
    sum
  end

end
