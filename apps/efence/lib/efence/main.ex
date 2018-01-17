defmodule Efence.Main do
  @moduledoc false

  use GenServer
  require Logger

  @main_ets :main_ets

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def run() do
    Logger.info("#{__MODULE__} start")
    GenServer.call(__MODULE__, :run)
  end

  def init(:ok) do
    :ets.new(@main_ets, [:named_table, read_concurrency: true])

    Logger.info("#{__MODULE__} init")
    {:ok, %{}}
  end

  def handle_call(:run, _from, state) do

    {:reply, :ok, state}
  end

  def handle_call(msg, _from, state) do
    Logger.info("#{__MODULE__} #{self()} gets unexpected msg: #{msg}")
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

end