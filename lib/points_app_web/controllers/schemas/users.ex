defmodule PointsAppWeb.Controllers.Schemas.Users do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  defmodule User do
    OpenApiSpex.schema(%{
      title: "Users.User",
      type: :object,
      properties: %{
        id: %Schema{type: :number},
        points: %Schema{type: :number},
        inserted_at: %Schema{type: :string, format: :date_time},
        updated_at: %Schema{type: :string, format: :date_time}
      },
      additionalProperties: false,
      example: %{
        id: 1,
        points: 10,
        inserted_at: "2021-01-01T00:00:00Z",
        updated_at: "2021-01-01T00:00:00Z"
      }
    })
  end

  defmodule UsersResponse do
    OpenApiSpex.schema(%{
      title: "Users.UsersResponse",
      type: :object,
      properties: %{
        users: %Schema{
          type: :array,
          items: User
        },
        timestamp: %Schema{type: :string, format: :date_time}
      },
      additionalProperties: false,
      example: %{
        users: [
          %{
            id: 1,
            points: 10,
            inserted_at: "2021-01-01T00:00:00Z",
            updated_at: "2021-01-01T00:00:00Z"
          },
          %{
            id: 2,
            points: 20,
            inserted_at: "2021-01-01T00:00:00Z",
            updated_at: "2021-01-01T00:00:00Z"
          }
        ],
        timestamp: "2021-01-01T00:00:00Z"
      }
    })
  end
end
