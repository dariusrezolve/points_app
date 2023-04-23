ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PointsApp.Repo, :manual)

Mox.defmock(PointsApp.MockedPointsServerApi, for: PointsApp.PointsServerApi)
Mox.defmock(PointsApp.MockedDataUpdaterApi, for: PointsApp.DataUpdaterApi)

Application.put_env(:points_app, :data_updater_api, PointsApp.MockedDataUpdaterApi)
Application.put_env(:points_app, :points_server_api, PointsApp.MockedPointsServerApi)
