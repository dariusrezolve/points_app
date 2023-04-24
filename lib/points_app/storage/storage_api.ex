defmodule PointsApp.StorageApi do
  @callback get_users_with_more_points_than(number) :: list
  @callback update_all_users() :: :ok

  def get_users_with_more_points_than(number), do: impl().get_users_with_more_points_than(number)

  def update_all_users_at_once(), do: impl().update_all_users_at_once()
  def update_all_users_in_batches(), do: impl().update_all_users_in_batches()

  defp impl(), do: Application.get_env(:points_app, :storage_api, PointsApp.Storage)
end
