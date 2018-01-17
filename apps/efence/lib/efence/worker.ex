defmodule Efence.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:square_root, x}, _from, state) do
    IO.puts("process #{inspect(self())} calculating square root of #{x}")
    :timer.sleep(1000)
    {:reply, :math.sqrt(x), state}
  end

  def handle_call({:start, _efenceId, _deviceCode, _interval}, _from, state) do
    {:reply, :ok, state}
  end
end
