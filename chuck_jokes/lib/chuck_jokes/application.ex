defmodule ChuckJokes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChuckJokesWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:chuck_jokes, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChuckJokes.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChuckJokes.Finch},
      # Start a worker by calling: ChuckJokes.Worker.start_link(arg)
      # {ChuckJokes.Worker, arg},
      # Start to serve requests, typically the last entry
      ChuckJokesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChuckJokes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChuckJokesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
