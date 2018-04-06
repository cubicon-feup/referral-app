defmodule AppWeb.ContractControllerTest do
  use AppWeb.ConnCase

  alias App.Contracts
  alias App.Contracts.Contract

  @create_attrs %{current_amount: "120.5", is_requestable: true, minimum_amount_of_sales: "120.5", minimum_amout_of_views: 42, minimum_sales: "120.5", number_of_views: 42, percent_amount_on_sales: "120.5", send_notification_to_brand: true, send_notification_to_influencer: true, size_of_set_of_sales: 42, static_amount_on_sales: "120.5", static_amount_on_set_of_sales: "120.5", static_amount_on_views: "120.5", time_between_payments: 42}
  @update_attrs %{current_amount: "456.7", is_requestable: false, minimum_amount_of_sales: "456.7", minimum_amout_of_views: 43, minimum_sales: "456.7", number_of_views: 43, percent_amount_on_sales: "456.7", send_notification_to_brand: false, send_notification_to_influencer: false, size_of_set_of_sales: 43, static_amount_on_sales: "456.7", static_amount_on_set_of_sales: "456.7", static_amount_on_views: "456.7", time_between_payments: 43}
  @invalid_attrs %{current_amount: nil, is_requestable: nil, minimum_amount_of_sales: nil, minimum_amout_of_views: nil, minimum_sales: nil, number_of_views: nil, percent_amount_on_sales: nil, send_notification_to_brand: nil, send_notification_to_influencer: nil, size_of_set_of_sales: nil, static_amount_on_sales: nil, static_amount_on_set_of_sales: nil, static_amount_on_views: nil, time_between_payments: nil}

  def fixture(:contract) do
    {:ok, contract} = Contracts.create_contract(@create_attrs)
    contract
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, contract_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create contract" do
    test "renders contract when data is valid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "current_amount" => "120.5",
        "is_requestable" => true,
        "minimum_amount_of_sales" => "120.5",
        "minimum_amout_of_views" => 42,
        "minimum_sales" => "120.5",
        "number_of_views" => 42,
        "percent_amount_on_sales" => "120.5",
        "send_notification_to_brand" => true,
        "send_notification_to_influencer" => true,
        "size_of_set_of_sales" => 42,
        "static_amount_on_sales" => "120.5",
        "static_amount_on_set_of_sales" => "120.5",
        "static_amount_on_views" => "120.5",
        "time_between_payments" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contract" do
    setup [:create_contract]

    test "renders contract when data is valid", %{conn: conn, contract: %Contract{id: id} = contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "current_amount" => "456.7",
        "is_requestable" => false,
        "minimum_amount_of_sales" => "456.7",
        "minimum_amout_of_views" => 43,
        "minimum_sales" => "456.7",
        "number_of_views" => 43,
        "percent_amount_on_sales" => "456.7",
        "send_notification_to_brand" => false,
        "send_notification_to_influencer" => false,
        "size_of_set_of_sales" => 43,
        "static_amount_on_sales" => "456.7",
        "static_amount_on_set_of_sales" => "456.7",
        "static_amount_on_views" => "456.7",
        "time_between_payments" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, contract: contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      conn = delete conn, contract_path(conn, :delete, contract)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, contract_path(conn, :show, contract)
      end
    end
  end

  defp create_contract(_) do
    contract = fixture(:contract)
    {:ok, contract: contract}
  end
end
