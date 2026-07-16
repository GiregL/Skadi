defmodule Skadi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SkadiWeb.Telemetry,
      Skadi.Repo,
      {DNSCluster, query: Application.get_env(:skadi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Skadi.PubSub},
      # Start a worker by calling: Skadi.Worker.start_link(arg)
      # {Skadi.Worker, arg},
      # Start to serve requests, typically the last entry
      SkadiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Skadi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SkadiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
