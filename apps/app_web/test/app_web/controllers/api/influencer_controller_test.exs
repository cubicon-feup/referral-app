defmodule AppWeb.Api.InfluencerControllerTest do
  use AppWeb.ConnCase

  alias App.Influencers
  alias App.Influencers.Influencer

  @create_attrs %{address: "some address", code: "some code", name: "some name", nib: 42, contact: "some contact"}
  @update_attrs %{address: "some updated address", code: "some updated code", name: "some updated name", nib: 43, contact: "some updated contact"}
  @invalid_attrs %{address: nil, code: nil, name: nil, nib: nil , contact: nil}

  def fixture(:influencer) do
    {:ok, influencer} = Influencers.create_influencer(@create_attrs)
    influencer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create influencer" do
    test "renders influencer when data is valid", %{conn: conn} do
      conn = post conn, api_influencer_path(conn, :create), influencer: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_influencer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address" => "some address",
        "code" => "some code",
        "name" => "some name",
        "nib" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_influencer_path(conn, :create), influencer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update influencer" do
    setup [:create_influencer]

    test "renders influencer when data is valid", %{conn: conn, influencer: %Influencer{id: id} = influencer} do
      conn = put conn, api_influencer_path(conn, :update, influencer), influencer: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_influencer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address" => "some updated address",
        "code" => "some updated code",
        "name" => "some updated name",
        "nib" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, influencer: influencer} do
      conn = put conn, api_influencer_path(conn, :update, influencer), influencer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete influencer" do
    setup [:create_influencer]

    test "deletes chosen influencer", %{conn: conn, influencer: influencer} do
      conn = delete conn, api_influencer_path(conn, :delete, influencer)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_influencer_path(conn, :show, influencer)
      end
    end
  end

  defp create_influencer(_) do
    influencer = fixture(:influencer)
    {:ok, influencer: influencer}
  end
end
