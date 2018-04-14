defmodule App.ContractsTest do
  use App.DataCase

  alias App.Contracts

  describe "contracts" do
    alias App.Contracts.Contract

    @valid_attrs %{current_amount: "120.5", is_requestable: true, minimum_amount_of_sales: "120.5", minimum_amout_of_views: 42, minimum_sales: "120.5", number_of_views: 42, percent_amount_on_sales: "120.5", send_notification_to_brand: true, send_notification_to_influencer: true, size_of_set_of_sales: 42, static_amount_on_sales: "120.5", static_amount_on_set_of_sales: "120.5", static_amount_on_views: "120.5", time_between_payments: 42}
    @update_attrs %{current_amount: "456.7", is_requestable: false, minimum_amount_of_sales: "456.7", minimum_amout_of_views: 43, minimum_sales: "456.7", number_of_views: 43, percent_amount_on_sales: "456.7", send_notification_to_brand: false, send_notification_to_influencer: false, size_of_set_of_sales: 43, static_amount_on_sales: "456.7", static_amount_on_set_of_sales: "456.7", static_amount_on_views: "456.7", time_between_payments: 43}
    @invalid_attrs %{current_amount: nil, is_requestable: nil, minimum_amount_of_sales: nil, minimum_amout_of_views: nil, minimum_sales: nil, number_of_views: nil, percent_amount_on_sales: nil, send_notification_to_brand: nil, send_notification_to_influencer: nil, size_of_set_of_sales: nil, static_amount_on_sales: nil, static_amount_on_set_of_sales: nil, static_amount_on_views: nil, time_between_payments: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contracts.create_contract()

      contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Contracts.list_contracts() == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Contracts.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      assert {:ok, %Contract{} = contract} = Contracts.create_contract(@valid_attrs)
      assert contract.current_amount == Decimal.new("120.5")
      assert contract.is_requestable == true
      assert contract.minimum_amount_of_sales == Decimal.new("120.5")
      assert contract.minimum_amout_of_views == 42
      assert contract.minimum_sales == Decimal.new("120.5")
      assert contract.number_of_views == 42
      assert contract.percent_amount_on_sales == Decimal.new("120.5")
      assert contract.send_notification_to_brand == true
      assert contract.send_notification_to_influencer == true
      assert contract.size_of_set_of_sales == 42
      assert contract.static_amount_on_sales == Decimal.new("120.5")
      assert contract.static_amount_on_set_of_sales == Decimal.new("120.5")
      assert contract.static_amount_on_views == Decimal.new("120.5")
      assert contract.time_between_payments == 42
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Contracts.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.current_amount == Decimal.new("456.7")
      assert contract.is_requestable == false
      assert contract.minimum_amount_of_sales == Decimal.new("456.7")
      assert contract.minimum_amout_of_views == 43
      assert contract.minimum_sales == Decimal.new("456.7")
      assert contract.number_of_views == 43
      assert contract.percent_amount_on_sales == Decimal.new("456.7")
      assert contract.send_notification_to_brand == false
      assert contract.send_notification_to_influencer == false
      assert contract.size_of_set_of_sales == 43
      assert contract.static_amount_on_sales == Decimal.new("456.7")
      assert contract.static_amount_on_set_of_sales == Decimal.new("456.7")
      assert contract.static_amount_on_views == Decimal.new("456.7")
      assert contract.time_between_payments == 43
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Contracts.update_contract(contract, @invalid_attrs)
      assert contract == Contracts.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{}} = Contracts.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_fixture()
      assert %Ecto.Changeset{} = Contracts.change_contract(contract)
    end
  end
end
