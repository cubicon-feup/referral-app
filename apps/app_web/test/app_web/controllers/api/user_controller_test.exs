defmodule AppWeb.Api.UserControllerTest do
  use AppWeb.ConnCase

  alias App.Users
  alias App.Users.User

  @create_attrs %{date_of_birth: ~D[2010-04-17], deleted: true, email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user"}
  @update_attrs %{date_of_birth: ~D[2011-05-18], deleted: false, email: "some updated email", name: "some updated name", password: "some updated password", picture_path: "some updated picture_path", privileges_level: "user"}
  @invalid_attrs %{date_of_birth: nil, deleted: nil, email: nil, name: nil, password: nil, picture_path: nil, privileges_level: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, api_user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, api_user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, api_user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
