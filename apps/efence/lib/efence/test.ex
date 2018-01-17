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
    device_code_list = String.split(params[:deviceCodes], ",")
                       |> Enum.map(fn i -> async_call_square_root(i) end)
                       |> Enum.each(fn task -> await_and_inspect(task) end)
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



end
