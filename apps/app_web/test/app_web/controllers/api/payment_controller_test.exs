defmodule AppWeb.Api.PaymentControllerTest do
  use AppWeb.ConnCase

  alias App.Payments
  alias App.Payments.Payment

  @create_attrs %{paid: true, request_date: ~N[2010-04-17 14:00:00.000000], value: "120.5"}
  @update_attrs %{paid: false, request_date: ~N[2011-05-18 15:01:01.000000], value: "456.7"}
  @invalid_attrs %{paid: nil, request_date: nil, value: nil}

  def fixture(:payment) do
    {:ok, payment} = Payments.create_payment(@create_attrs)
    payment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payments", %{conn: conn} do
      conn = get conn, api_payment_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment" do
    test "renders payment when data is valid", %{conn: conn} do
      conn = post conn, api_payment_path(conn, :create), payment: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_payment_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "paid" => true,
        "request_date" => "2010-04-17T14:00:00.000000",
        "value" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_payment_path(conn, :create), payment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment" do
    setup [:create_payment]

    test "renders payment when data is valid", %{conn: conn, payment: %Payment{id: id} = payment} do
      conn = put conn, api_payment_path(conn, :update, payment), payment: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_payment_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "paid" => false,
        "request_date" => "2011-05-18T15:01:01.000000",
        "value" => "456.7"}
    end

    test "renders errors when data is invalid", %{conn: conn, payment: payment} do
      conn = put conn, api_payment_path(conn, :update, payment), payment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete conn, api_payment_path(conn, :delete, payment)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_payment_path(conn, :show, payment)
      end
    end
  end

  defp create_payment(_) do
    payment = fixture(:payment)
    {:ok, payment: payment}
  end
end
