defmodule PointsApp.Repo do
  use Ecto.Repo,
    otp_app: :points_app,
    adapter: Ecto.Adapters.Postgres
end
