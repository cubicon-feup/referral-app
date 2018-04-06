defmodule AppWeb.VoucherControllerTest do
  use AppWeb.ConnCase

  alias App.Vouchers
  alias App.Vouchers.Voucher

  @create_attrs %{amount: "120.5", comulative_with_sales: true, comulative_with_vouchers: true, expiration_date: ~N[2010-04-17 14:00:00.000000], free_shipping: true, maximum_spent_to_use: "120.5", minimum_spent_to_use: "120.5", uses: 42, uses_per_person: 42}
  @update_attrs %{amount: "456.7", comulative_with_sales: false, comulative_with_vouchers: false, expiration_date: ~N[2011-05-18 15:01:01.000000], free_shipping: false, maximum_spent_to_use: "456.7", minimum_spent_to_use: "456.7", uses: 43, uses_per_person: 43}
  @invalid_attrs %{amount: nil, comulative_with_sales: nil, comulative_with_vouchers: nil, expiration_date: nil, free_shipping: nil, maximum_spent_to_use: nil, minimum_spent_to_use: nil, uses: nil, uses_per_person: nil}

  def fixture(:voucher) do
    {:ok, voucher} = Vouchers.create_voucher(@create_attrs)
    voucher
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vouchers", %{conn: conn} do
      conn = get conn, voucher_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create voucher" do
    test "renders voucher when data is valid", %{conn: conn} do
      conn = post conn, voucher_path(conn, :create), voucher: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, voucher_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => "120.5",
        "comulative_with_sales" => true,
        "comulative_with_vouchers" => true,
        "expiration_date" => ~N[2010-04-17 14:00:00.000000],
        "free_shipping" => true,
        "maximum_spent_to_use" => "120.5",
        "minimum_spent_to_use" => "120.5",
        "uses" => 42,
        "uses_per_person" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, voucher_path(conn, :create), voucher: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update voucher" do
    setup [:create_voucher]

    test "renders voucher when data is valid", %{conn: conn, voucher: %Voucher{id: id} = voucher} do
      conn = put conn, voucher_path(conn, :update, voucher), voucher: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, voucher_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => "456.7",
        "comulative_with_sales" => false,
        "comulative_with_vouchers" => false,
        "expiration_date" => ~N[2011-05-18 15:01:01.000000],
        "free_shipping" => false,
        "maximum_spent_to_use" => "456.7",
        "minimum_spent_to_use" => "456.7",
        "uses" => 43,
        "uses_per_person" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, voucher: voucher} do
      conn = put conn, voucher_path(conn, :update, voucher), voucher: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete voucher" do
    setup [:create_voucher]

    test "deletes chosen voucher", %{conn: conn, voucher: voucher} do
      conn = delete conn, voucher_path(conn, :delete, voucher)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, voucher_path(conn, :show, voucher)
      end
    end
  end

  defp create_voucher(_) do
    voucher = fixture(:voucher)
    {:ok, voucher: voucher}
  end
end
