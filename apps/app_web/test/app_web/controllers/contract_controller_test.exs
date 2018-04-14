defmodule AppWeb.ContractControllerTest do
  use AppWeb.ConnCase

  alias App.Contracts

  @create_attrs %{current_amount: "120.5", is_requestable: true, minimum_amount_of_sales: "120.5", minimum_amout_of_views: 42, minimum_sales: "120.5", number_of_views: 42, percent_amount_on_sales: "120.5", send_notification_to_brand: true, send_notification_to_influencer: true, size_of_set_of_sales: 42, static_amount_on_sales: "120.5", static_amount_on_set_of_sales: "120.5", static_amount_on_views: "120.5", time_between_payments: 42}
  @update_attrs %{current_amount: "456.7", is_requestable: false, minimum_amount_of_sales: "456.7", minimum_amout_of_views: 43, minimum_sales: "456.7", number_of_views: 43, percent_amount_on_sales: "456.7", send_notification_to_brand: false, send_notification_to_influencer: false, size_of_set_of_sales: 43, static_amount_on_sales: "456.7", static_amount_on_set_of_sales: "456.7", static_amount_on_views: "456.7", time_between_payments: 43}
  @invalid_attrs %{current_amount: nil, is_requestable: nil, minimum_amount_of_sales: nil, minimum_amout_of_views: nil, minimum_sales: nil, number_of_views: nil, percent_amount_on_sales: nil, send_notification_to_brand: nil, send_notification_to_influencer: nil, size_of_set_of_sales: nil, static_amount_on_sales: nil, static_amount_on_set_of_sales: nil, static_amount_on_views: nil, time_between_payments: nil}

  def fixture(:contract) do
    {:ok, contract} = Contracts.create_contract(@create_attrs)
    contract
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, contract_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Contracts"
    end
  end

  describe "new contract" do
    test "renders form", %{conn: conn} do
      conn = get conn, contract_path(conn, :new)
      assert html_response(conn, 200) =~ "New Contract"
    end
  end

  describe "create contract" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == contract_path(conn, :show, id)

      conn = get conn, contract_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Contract"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @invalid_attrs
      assert html_response(conn, 200) =~ "New Contract"
    end
  end

  describe "edit contract" do
    setup [:create_contract]

    test "renders form for editing chosen contract", %{conn: conn, contract: contract} do
      conn = get conn, contract_path(conn, :edit, contract)
      assert html_response(conn, 200) =~ "Edit Contract"
    end
  end

  describe "update contract" do
    setup [:create_contract]

    test "redirects when data is valid", %{conn: conn, contract: contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @update_attrs
      assert redirected_to(conn) == contract_path(conn, :show, contract)

      conn = get conn, contract_path(conn, :show, contract)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, contract: contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Contract"
    end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      conn = delete conn, contract_path(conn, :delete, contract)
      assert redirected_to(conn) == contract_path(conn, :index)
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
