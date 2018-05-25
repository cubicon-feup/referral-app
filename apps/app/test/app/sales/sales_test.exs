defmodule App.SalesTest do
  use App.DataCase
  
  alias App.Repo
  
  alias App.Contracts
  alias App.Users
  alias App.Brands
  alias App.Vouchers
  alias App.Sales

  describe "sales" do
    alias App.Sales.Sale
    
    @valid_attrs_user %{date_of_birth: ~D[2010-04-17], deleted: true, email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user" }
    @valid_attrs_brand %{ api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name" }
    @valid_attrs_contract %{email: "some@mail.com", address: "some address", name: "some name", nib: 33}
    @valid_attrs_voucher %{code: "some code"}
    
    @valid_attrs %{date: ~N[2010-04-17 14:00:00.000000], value: "120.5", voucher_id: 1}
    @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], value: "456.7", voucher_id: 1}
    @invalid_attrs %{date: nil, value: nil, voucher_id: nil}
    
    def user_fixture() do
      {:ok, user} = Users.create_user(@valid_attrs_user)
      user
    end

    def brand_fixture() do
      {:ok, brand} = Brands.create_brand(@valid_attrs_brand)
      brand
    end

    def contract_fixture() do
      brand = brand_fixture()
      user = user_fixture()
      {:ok, contract} =
        %{user_id: user.id, brand_id: brand.id}
        |> Enum.into(@valid_attrs_contract)
        |> Contracts.create_contract()

      contract
    end

    def voucher_fixture() do
      contract = contract_fixture()
      {:ok, voucher} =
        %{contract_id: contract.id}
        |> Enum.into(@valid_attrs_voucher)
        |> Vouchers.create_voucher()

      voucher
    end
    
    def sale_fixture(attrs \\ %{}) do
      voucher = voucher_fixture()
      {:ok, sale} =
        attrs
        |> Enum.into(%{voucher_id: voucher.id})
        |> Enum.into(@valid_attrs)
        |> Sales.create_sale()
    
      sale
    end
    
    test "list_sales/0 returns all sales" do
      sale = sale_fixture()
      assert Sales.list_sales() == [sale]
    end
    
    test "get_sale!/1 returns the sale with given id" do
      sale = sale_fixture()
      assert Sales.get_sale!(sale.id) == sale
    end
    
    test "create_sale/1 with valid data creates a sale" do
      voucher = voucher_fixture()
      assert {:ok, %Sale{} = sale} = %{voucher_id: voucher.id}
      |> Enum.into(@valid_attrs)
      |> Sales.create_sale()
      assert sale.date == ~N[2010-04-17 14:00:00.000000]
      assert sale.value == Decimal.new("120.5")
    end
    
    test "create_sale/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_sale(@invalid_attrs)
    end
    
    test "update_sale/2 with valid data updates the sale" do
      sale = sale_fixture()
      assert {:ok, sale} = Sales.update_sale(sale, @update_attrs)
      assert %Sale{} = sale
      assert sale.date == ~N[2011-05-18 15:01:01.000000]
      assert sale.value == Decimal.new("456.7")
    end
    
    test "update_sale/2 with invalid data returns error changeset" do
      sale = sale_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_sale(sale, @invalid_attrs)
      assert sale == Sales.get_sale!(sale.id)
    end
    
    test "delete_sale/1 deletes the sale" do
      sale = sale_fixture()
      assert {:ok, %Sale{}} = Sales.delete_sale(sale)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_sale!(sale.id) end
    end
    
    test "change_sale/1 returns a sale changeset" do
      sale = sale_fixture()
      assert %Ecto.Changeset{} = Sales.change_sale(sale)
    end
  end
end
