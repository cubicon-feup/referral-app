defmodule App.ContractsTest do
  use App.DataCase

  alias App.Contracts

  describe "contracts" do
    alias App.Contracts.Contract

    @valid_attrs %{brand_id: 42, influencer_id: 42, minimum_points: 42, payment_period: 42, points: 42}
    @update_attrs %{brand_id: 43, influencer_id: 43, minimum_points: 43, payment_period: 43, points: 43}
    @invalid_attrs %{brand_id: nil, influencer_id: nil, minimum_points: nil, payment_period: nil, points: nil}

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
      assert contract.brand_id == 42
      assert contract.influencer_id == 42
      assert contract.minimum_points == 42
      assert contract.payment_period == 42
      assert contract.points == 42
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Contracts.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.brand_id == 43
      assert contract.influencer_id == 43
      assert contract.minimum_points == 43
      assert contract.payment_period == 43
      assert contract.points == 43
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
