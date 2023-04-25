defmodule PointApp.PointsServerTest do
  use ExUnit.Case
  use PointsApp.DataCase
  alias PointsApp.PointsServer
  import Mox
  import PointsApp.StorageFixtures

  setup :verify_on_exit!

  describe "handle_info" do
    test "the min_number is refreshed on timer tick" do
      PointsApp.MockedDataUpdaterApi
      |> expect(:update_data, fn -> :ok end)

      {:noreply, %{min_number: min_number}} =
        PointsServer.handle_info(:timer_tick, %{timestamp: nil, min_number: -1})

      # min_number should be refreshed
      assert min_number != -1
    end
  end

  describe "handle_call" do
    test "timestamp is refreshed and previous timestamp is retrieved" do
      user_fixture()
      user_fixture()
      # make sure it's in the past
      call_timestamp =
        DateTime.utc_now() |> DateTime.add(-5, :second) |> DateTime.truncate(:second)

      {:reply, %{timestamp: previous_call_timestamp}, %{timestamp: new_call_timestamp}} =
        PointsServer.handle_call(:get_winners, nil, %{
          timer: nil,
          timestamp: call_timestamp,
          min_number: 0
        })

      assert previous_call_timestamp == call_timestamp
      assert new_call_timestamp > call_timestamp
    end

    test "at most 2 users with more points than min_number are retrieved" do
      min_number = 15
      _user1 = user_fixture(%{points: 10})
      _user2 = user_fixture(%{points: 20})
      _user3 = user_fixture(%{points: 30})
      _user3 = user_fixture(%{points: 80})

      {:reply, %{users: users}, _} =
        PointsServer.handle_call(:get_winners, nil, %{
          timestamp: nil,
          min_number: min_number
        })

      assert length(users) == 2
      assert Enum.all?(users, &(&1.points > min_number))
    end
  end
end
