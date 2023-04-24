defmodule PointsApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PointsAppWeb.Telemetry,
      # Start the Ecto repository
      PointsApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PointsApp.PubSub},
      # Start Finch
      {Finch, name: PointsApp.Finch},
      # Start the Endpoint (http/https)
      PointsAppWeb.Endpoint
      # Start a worker by calling: PointsApp.Worker.start_link(arg)
      # {PointsApp.Worker, arg}
    ]

    all_children =
      case Mix.env() do
        # we don't want to start these Genservers in test mode
        :test ->
          children

        _ ->
          children ++ [PointsApp.PointsServer, PointsApp.DataUpdater]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PointsApp.Supervisor]
    Supervisor.start_link(all_children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PointsAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
