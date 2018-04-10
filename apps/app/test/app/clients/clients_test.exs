defmodule App.ClientsTest do
  use App.DataCase

  alias App.Clients

  describe "client" do
    alias App.Clients.Client

    @valid_attrs %{age: 42, client_id: 42, country: "some country", gender: true}
    @update_attrs %{age: 43, client_id: 43, country: "some updated country", gender: false}
    @invalid_attrs %{age: nil, client_id: nil, country: nil, gender: nil}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_client()

      client
    end

    test "list_client/0 returns all client" do
      client = client_fixture()
      assert Clients.list_client() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Clients.create_client(@valid_attrs)
      assert client.age == 42
      assert client.client_id == 42
      assert client.country == "some country"
      assert client.gender == true
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, client} = Clients.update_client(client, @update_attrs)
      assert %Client{} = client
      assert client.age == 43
      assert client.client_id == 43
      assert client.country == "some updated country"
      assert client.gender == false
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end

  describe "clients" do
    alias App.Clients.Client

    @valid_attrs %{age: 42, client_id: 42, country: "some country", gender: true}
    @update_attrs %{age: 43, client_id: 43, country: "some updated country", gender: false}
    @invalid_attrs %{age: nil, client_id: nil, country: nil, gender: nil}

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clients.create_client()

      client
    end

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Clients.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Clients.create_client(@valid_attrs)
      assert client.age == 42
      assert client.client_id == 42
      assert client.country == "some country"
      assert client.gender == true
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, client} = Clients.update_client(client, @update_attrs)
      assert %Client{} = client
      assert client.age == 43
      assert client.client_id == 43
      assert client.country == "some updated country"
      assert client.gender == false
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end
end
