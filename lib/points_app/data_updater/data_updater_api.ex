defmodule PointsApp.DataUpdaterApi do
  @callback update_data() :: :ok

  def update_data(), do: impl().update_data()

  defp impl(), do: Application.get_env(:points_app, :data_updater_api, PointsApp.DataUpdater)
end
