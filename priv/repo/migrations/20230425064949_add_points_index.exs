defmodule PointsApp.Repo.Migrations.AddPointsIndex do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create_if_not_exists(index(:users, [:points], name: :users_points_idx, concurrently: true))
  end
end
