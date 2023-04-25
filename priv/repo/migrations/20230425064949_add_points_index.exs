defmodule PointsApp.Repo.Migrations.AddPointsIndex do
  use Ecto.Migration

  def change do
    create_if_not_exists(index(:users, [:points], name: :users_points_idx))
  end
end
