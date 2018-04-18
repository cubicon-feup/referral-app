defmodule App.UsersTest do
  use App.DataCase

  alias App.Users

  describe "users" do
    alias App.Users.User

    @valid_attrs %{date_of_birth: ~D[2010-04-17], deleted: true, email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "some privileges_level"}
    @update_attrs %{date_of_birth: ~D[2011-05-18], deleted: false, email: "some updated email", name: "some updated name", password: "some updated password", picture_path: "some updated picture_path", privileges_level: "some updated privileges_level"}
    @invalid_attrs %{date_of_birth: nil, deleted: nil, email: nil, name: nil, password: nil, picture_path: nil, privileges_level: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.date_of_birth == ~D[2010-04-17]
      assert user.deleted == true
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.picture_path == "some picture_path"
      assert user.privileges_level == "some privileges_level"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Users.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.date_of_birth == ~D[2011-05-18]
      assert user.deleted == false
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
      assert user.picture_path == "some updated picture_path"
      assert user.privileges_level == "some updated privileges_level"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
