defmodule App.ContractsTest do
  use App.DataCase

  alias App.Contracts
  alias App.Influencers
  alias App.Brands

  describe "contracts" do
    alias App.Contracts.Contract

    @valid_attrs_influencer %{address: "some address", name: "some name", nib: 42, contact:"some contact"}
    @valid_attrs_brand %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}

    @valid_attrs %{minimum_points: 42, payment_period: 42, points: 42}
    @update_attrs %{minimum_points: 43, payment_period: 43, points: 43}
    @invalid_attrs %{brand_id: nil, influencer_id: nil, minimum_points: nil, payment_period: nil, points: nil}

    def influencer_fixture() do
      {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)

      influencer
    end

    def brand_fixture() do
      {:ok, brand} = Brands.create_brand(@valid_attrs_brand)

      brand
    end

    def contract_fixture(attrs \\ %{}) do
      influencer = influencer_fixture()
      brand = brand_fixture()

      {:ok, contract} =
        attrs
        |> Enum.into(%{influencer_id: influencer.id, brand_id: brand.id})
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
      influencer = influencer_fixture()
      brand = brand_fixture()

      assert {:ok, %Contract{} = contract} =
        %{influencer_id: influencer.id, brand_id: brand.id}
        |> Enum.into(@valid_attrs)
        |> Contracts.create_contract()
      assert contract.minimum_points == 42
      assert contract.payment_period == 42
      assert contract.points == Decimal.new("42")
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Contracts.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.minimum_points == 43
      assert contract.payment_period == 43
      assert contract.points == Decimal.new("43")
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
