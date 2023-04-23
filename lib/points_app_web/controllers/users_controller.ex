defmodule PointsAppWeb.UsersController do
  use PointsAppWeb, :controller
  alias PointsApp.PointsServerApi
  alias OpenApiSpex.Operation
  alias PointsAppWeb.Controllers.Schemas.{GenericErrorResp, Users}

  def open_api_operation(action) do
    apply(__MODULE__, :"#{action}_operation", [])
  end

  def get_users_operation() do
    %Operation{
      tags: ["Users"],
      operationId: "getUsers",
      summary: "Get at most 2 users which have more points than an internally generated number",
      description:
        "Get at most 2 users which have more points than an internally generated number and the timestamp of the last call",
      responses: %{
        200 =>
          Operation.response(
            "Users that match the criteria",
            "application/json",
            Users.UsersResponse
          ),
        500 => Operation.response("Internal error", "application/json", GenericErrorResp)
      }
    }
  end

  def get_users(conn, _params) do
    response = PointsServerApi.get_users()
    users = Enum.map(Map.get(response, :users), &users_mapper/1)

    conn
    |> put_status(200)
    |> json(%{
      users: users,
      timestamp: Map.get(response, :timestamp)
    })
  end

  defp users_mapper(user) do
    %{
      id: Map.get(user, :id),
      points: Map.get(user, :points),
      inserted_at: Map.get(user, :inserted_at),
      updated_at: Map.get(user, :updated_at)
    }
  end
end
