defmodule PointsApp.StorageTest do
  use PointsApp.DataCase

  alias PointsApp.Storage

  describe "users" do
    alias PointsApp.Storage.User

    import PointsApp.StorageFixtures

    @invalid_attrs %{points: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Storage.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Storage.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{points: 42}

      assert {:ok, %User{} = user} = Storage.create_user(valid_attrs)
      assert user.points == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{points: 43}

      assert {:ok, %User{} = user} = Storage.update_user(user, update_attrs)
      assert user.points == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_user(user, @invalid_attrs)
      assert user == Storage.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Storage.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Storage.change_user(user)
    end
  end
end
