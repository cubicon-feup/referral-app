defmodule AppWeb.Api.VoucherControllerTest do
  use AppWeb.ConnCase

  alias App.Vouchers
  alias App.Vouchers.Voucher

  @create_attrs %{code: "some code"}
  @update_attrs %{code: "some updated code"}
  @invalid_attrs %{code: nil}

  def fixture(:voucher) do
    {:ok, voucher} = Vouchers.create_voucher(@create_attrs)
    voucher
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vouchers", %{conn: conn} do
      conn = get conn, api_voucher_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create voucher" do
    test "renders voucher when data is valid", %{conn: conn} do
      conn = post conn, api_voucher_path(conn, :create), voucher: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_voucher_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some code"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_voucher_path(conn, :create), voucher: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update voucher" do
    setup [:create_voucher]

    test "renders voucher when data is valid", %{conn: conn, voucher: %Voucher{id: id} = voucher} do
      conn = put conn, api_voucher_path(conn, :update, voucher), voucher: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_voucher_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some updated code"}
    end

    test "renders errors when data is invalid", %{conn: conn, voucher: voucher} do
      conn = put conn, api_voucher_path(conn, :update, voucher), voucher: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete voucher" do
    setup [:create_voucher]

    test "deletes chosen voucher", %{conn: conn, voucher: voucher} do
      conn = delete conn, api_voucher_path(conn, :delete, voucher)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_voucher_path(conn, :show, voucher)
      end
    end
  end

  defp create_voucher(_) do
    voucher = fixture(:voucher)
    {:ok, voucher: voucher}
  end
end
