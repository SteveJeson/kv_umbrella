defmodule Efence.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  defp poolboy_config do
    [
        {:name, {:local, :worker}},
        {:worker_module, Efence.Worker},
        {:size, 10000},
        {:max_overflow, 2},
      {:node, "192.168.1.113"}
    ]
  end

  def start(_type, _args) do
    Logger.info("#{__MODULE__} application start")

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: PoolboyApp.Worker.start_link(arg)
      # {PoolboyApp.Worker, arg},
      :poolboy.child_spec(:worker, poolboy_config())
#      :poolboy.child_spec(:worker1, poolboy_config())
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PoolboyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
