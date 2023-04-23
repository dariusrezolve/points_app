defmodule PointsApp.Storage.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          points: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @fields [:id, :points, :inserted_at, :updated_at]
  schema "users" do
    field :points, :integer
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@fields -- [:id, :inserted_at, :updated_at])
  end
end
