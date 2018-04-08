defmodule AppWeb.Payment_voucherControllerTest do
  use AppWeb.ConnCase

  alias App.Payment_vouchers
  alias App.Payment_vouchers.Payment_voucher

  @create_attrs %{amount: "120.5", comulative_with_sales: true, comulative_with_vouchers: true, expiration_date: ~N[2010-04-17 14:00:00.000000], maximum_spent_to_use: "120.5", minimum_spent_to_use: "120.5"}
  @update_attrs %{amount: "456.7", comulative_with_sales: false, comulative_with_vouchers: false, expiration_date: ~N[2011-05-18 15:01:01.000000], maximum_spent_to_use: "456.7", minimum_spent_to_use: "456.7"}
  @invalid_attrs %{amount: nil, comulative_with_sales: nil, comulative_with_vouchers: nil, expiration_date: nil, maximum_spent_to_use: nil, minimum_spent_to_use: nil}

  def fixture(:payment_voucher) do
    {:ok, payment_voucher} = Payment_vouchers.create_payment_voucher(@create_attrs)
    payment_voucher
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_voucher", %{conn: conn} do
      conn = get conn, payment_voucher_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment_voucher" do
    test "renders payment_voucher when data is valid", %{conn: conn} do
      conn = post conn, payment_voucher_path(conn, :create), payment_voucher: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, payment_voucher_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => "120.5",
        "comulative_with_sales" => true,
        "comulative_with_vouchers" => true,
        "expiration_date" => ~N[2010-04-17 14:00:00.000000],
        "maximum_spent_to_use" => "120.5",
        "minimum_spent_to_use" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_voucher_path(conn, :create), payment_voucher: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment_voucher" do
    setup [:create_payment_voucher]

    test "renders payment_voucher when data is valid", %{conn: conn, payment_voucher: %Payment_voucher{id: id} = payment_voucher} do
      conn = put conn, payment_voucher_path(conn, :update, payment_voucher), payment_voucher: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, payment_voucher_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => "456.7",
        "comulative_with_sales" => false,
        "comulative_with_vouchers" => false,
        "expiration_date" => ~N[2011-05-18 15:01:01.000000],
        "maximum_spent_to_use" => "456.7",
        "minimum_spent_to_use" => "456.7"}
    end

    test "renders errors when data is invalid", %{conn: conn, payment_voucher: payment_voucher} do
      conn = put conn, payment_voucher_path(conn, :update, payment_voucher), payment_voucher: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment_voucher" do
    setup [:create_payment_voucher]

    test "deletes chosen payment_voucher", %{conn: conn, payment_voucher: payment_voucher} do
      conn = delete conn, payment_voucher_path(conn, :delete, payment_voucher)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, payment_voucher_path(conn, :show, payment_voucher)
      end
    end
  end

  defp create_payment_voucher(_) do
    payment_voucher = fixture(:payment_voucher)
    {:ok, payment_voucher: payment_voucher}
  end
end
