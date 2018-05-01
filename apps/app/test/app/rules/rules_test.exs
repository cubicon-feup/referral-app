defmodule App.RulesTest do
  use App.DataCase

  alias App.Rules
  alias App.Influencers
  alias App.Brands
  alias App.Contracts

  describe "rules" do
    alias App.Rules.Rule

    @valid_attrs_influencer %{address: "some address", code: "some code", name: "some name", nib: 42}
    @valid_attrs_brand %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}
    @valid_attrs_contract %{minimum_points: 42, payment_period: 42, points: 42}
  
    @valid_attrs %{percent_on_sales: "120.5", points_on_sales: 42, points_on_views: 42, points_per_month: 42, sales_counter: 42, set_of_sales: 42, set_of_views: 42, views_counter: 42}
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

    def rule_fixture(attrs \\ %{}) do
      contract = contract_fixture()
      {:ok, rule} =
        attrs
        |> Enum.into(%{contract_id: contract.id})
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
      contract = contract_fixture();
      attrs = Enum.into(%{contract_id: contract.id}, @valid_attrs)
      assert {:ok, %Rule{} = rule} = Rules.create_rule(attrs)
      assert rule.percent_on_sales == Decimal.new("120.5")
      assert rule.points_on_sales ==  Decimal.new("42")
      assert rule.points_on_views == Decimal.new("42")
      assert rule.points_per_month == Decimal.new("42")
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
      assert rule.percent_on_sales == Decimal.new("456.7")
      assert rule.points_on_sales == Decimal.new("43")
      assert rule.points_on_views == Decimal.new("43")
      assert rule.points_per_month == Decimal.new("43")
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
