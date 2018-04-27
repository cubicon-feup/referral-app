defmodule AppWeb.RuleControllerTest do
  use AppWeb.ConnCase

  alias App.Rules
  alias App.Influencers
  alias App.Brands
  alias App.Contracts

  @valid_attrs_influencer %{address: "some address", code: "some code", name: "some name", nib: 42}
  @valid_attrs_brand %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}
  @valid_attrs_contract %{minimum_points: 42, payment_period: 42, points: 42}
  
  @create_attrs %{percent_on_sales: "120.5", points_on_sales: 42, points_on_views: 42, points_per_month: 42, sales_counter: 42, set_of_sales: 42, set_of_views: 42, views_counter: 42}
  @update_attrs %{percent_on_sales: "456.7", points_on_sales: 43, points_on_views: 43, points_per_month: 43, sales_counter: 43, set_of_sales: 43, set_of_views: 43, views_counter: 43}
  @invalid_attrs %{contract_id: nil, percent_on_sales: nil, points_on_sales: nil, points_on_views: nil, points_per_month: nil, sales_counter: nil, set_of_sales: nil, set_of_views: nil, views_counter: nil}


  def influencer_fixture() do
    {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)
    influencer
  end

  def brand_fixture() do
    {:ok, brand} = Brands.create_brand(@valid_attrs_brand)
    brand
  end

  def contract_fixture() do
    influencer = influencer_fixture()
    brand = brand_fixture()
    {:ok, contract} =
      %{influencer_id: influencer.id, brand_id: brand.id}
      |> Enum.into(@valid_attrs_contract)
      |> Contracts.create_contract()
    contract
  end

  def fixture(:rule) do
    contract = contract_fixture()
    {:ok, rule} =
      %{contract_id: contract.id}
      |> Enum.into(@create_attrs)
      |> Rules.create_rule()
    rule
  end

  describe "index" do
    test "lists all rules", %{conn: conn} do
      conn = get conn, rule_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Rules"
    end
  end

  describe "new rule" do
    test "renders form", %{conn: conn} do
      conn = get conn, rule_path(conn, :new)
      assert html_response(conn, 200) =~ "New Rule"
    end
  end

  describe "create rule" do
    test "redirects to show when data is valid", %{conn: conn} do
      contract = contract_fixture()
      attrs = Enum.into(%{contract_id: contract.id}, @create_attrs)

      conn = post conn, rule_path(conn, :create), rule: attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == rule_path(conn, :show, id)

      conn = get conn, rule_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Rule"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, rule_path(conn, :create), rule: @invalid_attrs
      assert html_response(conn, 200) =~ "New Rule"
    end
  end

  describe "edit rule" do
    setup [:create_rule]

    test "renders form for editing chosen rule", %{conn: conn, rule: rule} do
      conn = get conn, rule_path(conn, :edit, rule)
      assert html_response(conn, 200) =~ "Edit Rule"
    end
  end

  describe "update rule" do
    setup [:create_rule]

    test "redirects when data is valid", %{conn: conn, rule: rule} do
      contract = contract_fixture()
      attrs = Enum.into(%{contract_id: contract.id}, @update_attrs)

      conn = put conn, rule_path(conn, :update, rule), rule: attrs
      assert redirected_to(conn) == rule_path(conn, :show, rule)

      conn = get conn, rule_path(conn, :show, rule)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, rule: rule} do
      conn = put conn, rule_path(conn, :update, rule), rule: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Rule"
    end
  end

  describe "delete rule" do
    setup [:create_rule]

    test "deletes chosen rule", %{conn: conn, rule: rule} do
      conn = delete conn, rule_path(conn, :delete, rule)
      assert redirected_to(conn) == rule_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, rule_path(conn, :show, rule)
      end
    end
  end

  defp create_rule(_) do
    rule = fixture(:rule)
    {:ok, rule: rule}
  end
end
