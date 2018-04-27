defmodule App.RulesTest do
  use App.DataCase

  alias App.Rules

  describe "rules" do
    alias App.Rules.Rule

    @valid_attrs %{contract_id: 42, percent_on_sales: "120.5", points_on_sales: 42, points_on_views: 42, points_per_month: 42, sales_counter: 42, set_of_sales: 42, set_of_views: 42, views_counter: 42}
    @update_attrs %{contract_id: 43, percent_on_sales: "456.7", points_on_sales: 43, points_on_views: 43, points_per_month: 43, sales_counter: 43, set_of_sales: 43, set_of_views: 43, views_counter: 43}
    @invalid_attrs %{contract_id: nil, percent_on_sales: nil, points_on_sales: nil, points_on_views: nil, points_per_month: nil, sales_counter: nil, set_of_sales: nil, set_of_views: nil, views_counter: nil}

    def rule_fixture(attrs \\ %{}) do
      {:ok, rule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rules.create_rule()

      rule
    end

    test "list_rules/0 returns all rules" do
      rule = rule_fixture()
      assert Rules.list_rules() == [rule]
    end

    test "get_rule!/1 returns the rule with given id" do
      rule = rule_fixture()
      assert Rules.get_rule!(rule.id) == rule
    end

    test "create_rule/1 with valid data creates a rule" do
      assert {:ok, %Rule{} = rule} = Rules.create_rule(@valid_attrs)
      assert rule.contract_id == 42
      assert rule.percent_on_sales == Decimal.new("120.5")
      assert rule.points_on_sales == 42
      assert rule.points_on_views == 42
      assert rule.points_per_month == 42
      assert rule.sales_counter == 42
      assert rule.set_of_sales == 42
      assert rule.set_of_views == 42
      assert rule.views_counter == 42
    end

    test "create_rule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rules.create_rule(@invalid_attrs)
    end

    test "update_rule/2 with valid data updates the rule" do
      rule = rule_fixture()
      assert {:ok, rule} = Rules.update_rule(rule, @update_attrs)
      assert %Rule{} = rule
      assert rule.contract_id == 43
      assert rule.percent_on_sales == Decimal.new("456.7")
      assert rule.points_on_sales == 43
      assert rule.points_on_views == 43
      assert rule.points_per_month == 43
      assert rule.sales_counter == 43
      assert rule.set_of_sales == 43
      assert rule.set_of_views == 43
      assert rule.views_counter == 43
    end

    test "update_rule/2 with invalid data returns error changeset" do
      rule = rule_fixture()
      assert {:error, %Ecto.Changeset{}} = Rules.update_rule(rule, @invalid_attrs)
      assert rule == Rules.get_rule!(rule.id)
    end

    test "delete_rule/1 deletes the rule" do
      rule = rule_fixture()
      assert {:ok, %Rule{}} = Rules.delete_rule(rule)
      assert_raise Ecto.NoResultsError, fn -> Rules.get_rule!(rule.id) end
    end

    test "change_rule/1 returns a rule changeset" do
      rule = rule_fixture()
      assert %Ecto.Changeset{} = Rules.change_rule(rule)
    end
  end
end
