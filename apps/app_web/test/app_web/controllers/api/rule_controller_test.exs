defmodule AppWeb.Api.RuleControllerTest do
  use AppWeb.ConnCase

  alias App.Rules
  alias App.Rules.Rule

  @create_attrs %{contract_id: 42, percent_on_sales: "120.5", points_on_sales: 42, points_on_views: 42, points_per_month: 42, sales_counter: 42, set_of_sales: 42, set_of_views: 42, views_counter: 42}
  @update_attrs %{contract_id: 43, percent_on_sales: "456.7", points_on_sales: 43, points_on_views: 43, points_per_month: 43, sales_counter: 43, set_of_sales: 43, set_of_views: 43, views_counter: 43}
  @invalid_attrs %{contract_id: nil, percent_on_sales: nil, points_on_sales: nil, points_on_views: nil, points_per_month: nil, sales_counter: nil, set_of_sales: nil, set_of_views: nil, views_counter: nil}

  def fixture(:rule) do
    {:ok, rule} = Rules.create_rule(@create_attrs)
    rule
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rules", %{conn: conn} do
      conn = get conn, api_rule_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create rule" do
    test "renders rule when data is valid", %{conn: conn} do
      conn = post conn, api_rule_path(conn, :create), rule: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_rule_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "contract_id" => 42,
        "percent_on_sales" => "120.5",
        "points_on_sales" => 42,
        "points_on_views" => 42,
        "points_per_month" => 42,
        "sales_counter" => 42,
        "set_of_sales" => 42,
        "set_of_views" => 42,
        "views_counter" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_rule_path(conn, :create), rule: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update rule" do
    setup [:create_rule]

    test "renders rule when data is valid", %{conn: conn, rule: %Rule{id: id} = rule} do
      conn = put conn, api_rule_path(conn, :update, rule), rule: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_rule_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "contract_id" => 43,
        "percent_on_sales" => "456.7",
        "points_on_sales" => 43,
        "points_on_views" => 43,
        "points_per_month" => 43,
        "sales_counter" => 43,
        "set_of_sales" => 43,
        "set_of_views" => 43,
        "views_counter" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, rule: rule} do
      conn = put conn, api_rule_path(conn, :update, rule), rule: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete rule" do
    setup [:create_rule]

    test "deletes chosen rule", %{conn: conn, rule: rule} do
      conn = delete conn, api_rule_path(conn, :delete, rule)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_rule_path(conn, :show, rule)
      end
    end
  end

  defp create_rule(_) do
    rule = fixture(:rule)
    {:ok, rule: rule}
  end
end
