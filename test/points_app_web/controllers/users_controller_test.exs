defmodule PointsAppWeb.PageControllerTest do
  use PointsAppWeb.ConnCase
  import Mox
  import PointsApp.StorageFixtures
  import OpenApiSpex.TestAssertions

  test "GET /", %{conn: conn} do
    Application.put_env(:points_app, :points_server_api, PointsApp.MockedPointsServerApi)

    user1 = user_fixture(%{points: 10})
    user2 = user_fixture(%{points: 20})

    PointsApp.MockedPointsServerApi
    |> expect(:get_users, fn -> %{timestamp: DateTime.utc_now(), users: [user1, user2]} end)

    json = conn |> get(~p"/") |> json_response(200)

    api_spec = PointsApp.ApiSpec.spec()

    assert_schema(
      json,
      "Users.UsersResponse",
      api_spec
    )
  end
end
