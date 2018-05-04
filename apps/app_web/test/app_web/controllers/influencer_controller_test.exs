defmodule AppWeb.InfluencerControllerTest do
  use AppWeb.ConnCase

  alias App.Influencers

  @create_attrs %{address: "some address", name: "some name", nib: 42}
  @update_attrs %{address: "some updated address", name: "some updated name", nib: 43}
  @invalid_attrs %{address: nil, name: nil, nib: nil}

  def fixture(:influencer) do
    {:ok, influencer} = Influencers.create_influencer(@create_attrs)
    influencer
  end


  describe "new influencer" do
    test "renders form", %{conn: conn} do
      conn = get conn, influencer_path(conn, :new)
      assert html_response(conn, 200) =~ "New Influencer"
    end
  end

  describe "create influencer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, influencer_path(conn, :create), influencer: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == influencer_path(conn, :show, id)

      conn = get conn, influencer_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Influencer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, influencer_path(conn, :create), influencer: @invalid_attrs
      assert html_response(conn, 200) =~ "New Influencer"
    end
  end

  describe "edit influencer" do
    setup [:create_influencer]

    test "renders form for editing chosen influencer", %{conn: conn, influencer: influencer} do
      conn = get conn, influencer_path(conn, :edit, influencer)
      assert html_response(conn, 200) =~ "Edit Influencer"
    end
  end

  describe "update influencer" do
    setup [:create_influencer]

    test "redirects when data is valid", %{conn: conn, influencer: influencer} do
      conn = put conn, influencer_path(conn, :update, influencer), influencer: @update_attrs
      assert redirected_to(conn) == influencer_path(conn, :show, influencer)

      conn = get conn, influencer_path(conn, :show, influencer)
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, influencer: influencer} do
      conn = put conn, influencer_path(conn, :update, influencer), influencer: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Influencer"
    end
  end

  describe "delete influencer" do
    setup [:create_influencer]

    test "deletes chosen influencer", %{conn: conn, influencer: influencer} do
      conn = delete conn, influencer_path(conn, :delete, influencer)
      assert redirected_to(conn) == influencer_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, influencer_path(conn, :show, influencer)
      end
    end
  end

  defp create_influencer(_) do
    influencer = fixture(:influencer)
    {:ok, influencer: influencer}
  end
end
