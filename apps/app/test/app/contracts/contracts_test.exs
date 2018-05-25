defmodule App.ContractsTest do
  use App.DataCase

  alias App.Repo
  
  alias App.Contracts
  alias App.Users
  alias App.Brands

  describe "contracts" do
    alias App.Contracts.Contract

    @valid_attrs_user %{
      date_of_birth: ~D[2010-04-17],
      deleted: true,
      email: "some email",
      name: "some name",
      password: "some password",
      picture_path: "some picture_path",
      privileges_level: "user"
    }
    
    @valid_attrs_brand %{
      api_key: "some api_key",
      api_password: "some api_password",
      hostname: "some hostname",
      name: "some name"
    }

    @valid_attrs %{email: "some@mail.com", address: "some address", name: "some name", nib: 33}
    @update_attrs %{email: "some2@mail.com", address: "some address2", name: "some name2", nib: 34}
    @invalid_attrs %{brand_id: nil, email: nil, address: nil, name: nil, nib: nil}

    defp create_contract(_) do
      contract = fixture(:contract)
      {:ok, contract: contract}
    end

    def user_fixture() do
      {:ok, user} = Users.create_user(@valid_attrs_user)
      user
    end

    def brand_fixture() do
      {:ok, brand} = Brands.create_brand(@valid_attrs_brand)
      brand
    end

    def contract_fixture(attrs \\ %{}) do
      brand = brand_fixture()
      user = user_fixture()
      {:ok, contract} =
        attrs
        |> Enum.into(%{user_id: user.id, brand_id: brand.id})
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
      assert Contracts.get_contract!(contract.id) == Repo.preload(contract, :voucher)
    end

    test "create_contract/1 with valid data creates a contract" do
      brand = brand_fixture()

      assert {:ok, %Contract{} = contract} =
        %{brand_id: brand.id}
        |> Enum.into(@valid_attrs)
        |> Contracts.create_contract()

      assert contract.minimum_points == 0
      assert contract.payment_period == 0
      assert contract.points == Decimal.new("0.0")
      assert contract.name == "some name"
      assert contract.email == "some@mail.com"
      assert contract.address == "some address"
      assert contract.nib == 33
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Contracts.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.minimum_points == 0
      assert contract.payment_period == 0
      assert contract.points == Decimal.new("0.0")
      assert contract.name == "some name2"
      assert contract.email == "some2@mail.com"
      assert contract.address == "some address2"
      assert contract.nib == 34
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Contracts.update_contract(contract, @invalid_attrs)
      assert Repo.preload(contract, :voucher) == Contracts.get_contract!(contract.id)
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

    #------------------------------------
    #------------------------------------
    #------------------------------------

    test "get_contract_by_email/1 returns a contract" do
      contract = contract_fixture()
      assert Contracts.get_contract_by_email!(contract.email) ==contract
    end

    test "get_contract_by_brand/1 returns a contract" do
      contract = contract_fixture()
      assert Contracts.get_contract_by_brand(contract.brand_id) ==contract
    end

    test "add_points/1 updates contract" do
      contract = contract_fixture()
      assert {:ok, updated_contract} = Contracts.add_points(contract, 3.0)
      assert updated_contract.points == Decimal.new("3.0")
    end

    test "add_points_2/1 updates contract" do
      contract = contract_fixture()
      assert {:ok, updated_contract} = Contracts.add_points_2(contract.id, 3.0)
      assert updated_contract.points == Decimal.new("3.0")
    end

    test "get_total_contract_revenue/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_total_contract_revenue(contract.id) == Decimal.new(0)
    end

    test "get_number_of_sales/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_number_of_sales(contract.id) == 0
    end

    test "get_total_contract_views/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_total_contract_views(contract.id) == 0
    end

    test "get_contract_customers/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_contract_customers(contract.id) == []
    end

    test "get_contract_pending_payments/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_contract_pending_payments(contract.id) == 0
    end

    test "get_sales_countries/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_sales_countries(contract.id) == []
    end

    test "get_brands/1 gets right result" do
      brand = brand_fixture()
      user = user_fixture()
      {:ok, contract} =
        %{user_id: user.id, brand_id: brand.id}
        |> Enum.into(@valid_attrs)
        |> Contracts.create_contract()
      assert Contracts.get_brands(contract) == [brand]
    end

    test "get_payments/1 gets right result" do
      contract = contract_fixture()
      assert Contracts.get_payments(contract) == []
    end
  end
end
