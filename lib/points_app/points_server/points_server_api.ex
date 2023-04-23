defmodule PointsApp.PointsServerApi do
  @callback get_users() :: map()

  def get_users(), do: impl().get_users()

  defp impl(), do: Application.get_env(:points_app, :points_server_api, PointsApp.PointsServer)
end
