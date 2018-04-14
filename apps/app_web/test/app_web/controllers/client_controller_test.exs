defmodule AppWeb.ClientControllerTest do
  use AppWeb.ConnCase

  alias App.Clients

  @create_attrs %{age: 42, client_id: 42, country: "some country", gender: true}
  @update_attrs %{age: 43, client_id: 43, country: "some updated country", gender: false}
  @invalid_attrs %{age: nil, client_id: nil, country: nil, gender: nil}

  def fixture(:client) do
    {:ok, client} = Clients.create_client(@create_attrs)
    client
  end

  describe "index" do
    test "lists all clients", %{conn: conn} do
      conn = get conn, client_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Clients"
    end
  end

  describe "new client" do
    test "renders form", %{conn: conn} do
      conn = get conn, client_path(conn, :new)
      assert html_response(conn, 200) =~ "New Client"
    end
  end

  describe "create client" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, client_path(conn, :create), client: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == client_path(conn, :show, id)

      conn = get conn, client_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Client"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, client_path(conn, :create), client: @invalid_attrs
      assert html_response(conn, 200) =~ "New Client"
    end
  end

  describe "edit client" do
    setup [:create_client]

    test "renders form for editing chosen client", %{conn: conn, client: client} do
      conn = get conn, client_path(conn, :edit, client)
      assert html_response(conn, 200) =~ "Edit Client"
    end
  end

  describe "update client" do
    setup [:create_client]

    test "redirects when data is valid", %{conn: conn, client: client} do
      conn = put conn, client_path(conn, :update, client), client: @update_attrs
      assert redirected_to(conn) == client_path(conn, :show, client)

      conn = get conn, client_path(conn, :show, client)
      assert html_response(conn, 200) =~ "some updated country"
    end

    test "renders errors when data is invalid", %{conn: conn, client: client} do
      conn = put conn, client_path(conn, :update, client), client: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Client"
    end
  end

  describe "delete client" do
    setup [:create_client]

    test "deletes chosen client", %{conn: conn, client: client} do
      conn = delete conn, client_path(conn, :delete, client)
      assert redirected_to(conn) == client_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, client_path(conn, :show, client)
      end
    end
  end

  defp create_client(_) do
    client = fixture(:client)
    {:ok, client: client}
  end
end
