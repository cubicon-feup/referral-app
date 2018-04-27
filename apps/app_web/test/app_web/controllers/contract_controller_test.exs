defmodule AppWeb.ContractControllerTest do
  use AppWeb.ConnCase

  alias App.Contracts

  @create_attrs %{brand_id: 42, influencer_id: 42, minimum_points: 42, payment_period: 42, points: 42}
  @update_attrs %{brand_id: 43, influencer_id: 43, minimum_points: 43, payment_period: 43, points: 43}
  @invalid_attrs %{brand_id: nil, influencer_id: nil, minimum_points: nil, payment_period: nil, points: nil}

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
