defmodule PointsApp.StorageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointsApp.Storage` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        points: 42
      })
      |> PointsApp.Storage.create_user()

    user
  end
end
