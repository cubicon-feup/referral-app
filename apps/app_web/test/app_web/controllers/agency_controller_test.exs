defmodule AppWeb.AgencyControllerTest do
  use AppWeb.ConnCase

  alias App.Agencies

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:agency) do
    {:ok, agency} = Agencies.create_agency(@create_attrs)
    agency
  end

  describe "index" do
    test "lists all agencies", %{conn: conn} do
      conn = get conn, agency_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Agencies"
    end
  end

  describe "new agency" do
    test "renders form", %{conn: conn} do
      conn = get conn, agency_path(conn, :new)
      assert html_response(conn, 200) =~ "New Agency"
    end
  end

  describe "create agency" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, agency_path(conn, :create), agency: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == agency_path(conn, :show, id)

      conn = get conn, agency_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Agency"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, agency_path(conn, :create), agency: @invalid_attrs
      assert html_response(conn, 200) =~ "New Agency"
    end
  end

  describe "edit agency" do
    setup [:create_agency]

    test "renders form for editing chosen agency", %{conn: conn, agency: agency} do
      conn = get conn, agency_path(conn, :edit, agency)
      assert html_response(conn, 200) =~ "Edit Agency"
    end
  end

  describe "update agency" do
    setup [:create_agency]

    test "redirects when data is valid", %{conn: conn, agency: agency} do
      conn = put conn, agency_path(conn, :update, agency), agency: @update_attrs
      assert redirected_to(conn) == agency_path(conn, :show, agency)

      conn = get conn, agency_path(conn, :show, agency)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, agency: agency} do
      conn = put conn, agency_path(conn, :update, agency), agency: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Agency"
    end
  end

  describe "delete agency" do
    setup [:create_agency]

    test "deletes chosen agency", %{conn: conn, agency: agency} do
      conn = delete conn, agency_path(conn, :delete, agency)
      assert redirected_to(conn) == agency_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, agency_path(conn, :show, agency)
      end
    end
  end

  defp create_agency(_) do
    agency = fixture(:agency)
    {:ok, agency: agency}
  end
end
