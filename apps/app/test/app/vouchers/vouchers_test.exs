defmodule App.VouchersTest do
  use App.DataCase

  alias App.Repo
  
  alias App.Contracts
  alias App.Users
  alias App.Brands
  alias App.Vouchers


  describe "vouchers" do
    alias App.Vouchers.Voucher

    @valid_attrs_user %{date_of_birth: ~D[2010-04-17], deleted: true, email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user" }
    @valid_attrs_brand %{ api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name" }
    @valid_attrs_contract %{email: "some@mail.com", address: "some address", name: "some name", nib: 33}
    
    @valid_attrs %{code: "some code"}
    @update_attrs %{code: "some updated code"}
    @invalid_attrs %{code: nil}

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

    def voucher_fixture(attrs \\ %{}) do
      contract = contract_fixture()
      {:ok, voucher} =
        attrs
        |> Enum.into(%{contract_id: contract.id})
        |> Enum.into(@valid_attrs)
        |> Vouchers.create_voucher()

      voucher
    end

    # test "list_vouchers/0 returns all vouchers" do
    #  voucher = voucher_fixture()
    #  IO.inspect(Vouchers.list_vouchers())
    #  assert Vouchers.list_vouchers() == [voucher]
    # end

    test "get_voucher!/1 returns the voucher with given id" do
      voucher = voucher_fixture()
      voucher_p=
        Repo.preload(voucher, :contract)
        |> Repo.preload(:sales)
      assert Vouchers.get_voucher!(voucher.id) == {:ok, voucher_p} 
    end

    test "create_voucher/1 with valid data creates a voucher" do
      contract = contract_fixture()

      assert {:ok, %Voucher{} = voucher} =  
        %{contract_id: contract.id}
        |> Enum.into(@valid_attrs)
        |> Vouchers.create_voucher()
        
      assert voucher.code == "some code"
      assert voucher.percent_on_sales ==  Decimal.new("0.1")
      assert voucher.points_on_sales == Decimal.new("0.0")
      assert voucher.points_on_views == Decimal.new("0.0")
      assert voucher.points_per_month == Decimal.new("0.0")
      assert voucher.sales_counter == 0
      assert voucher.set_of_sales == 1
      assert voucher.set_of_views == 1
      assert voucher.views_counter == 0
    end

    test "create_voucher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vouchers.create_voucher(@invalid_attrs)
    end

    test "update_voucher/2 with valid data updates the voucher" do
      voucher = voucher_fixture()
      assert {:ok, voucher} = Vouchers.update_voucher(voucher, @update_attrs)
      assert %Voucher{} = voucher
      assert voucher.code == "some updated code"
    end

    test "update_voucher/2 with invalid data returns error changeset" do
      voucher = voucher_fixture()
      voucher_p=
        Repo.preload(voucher, :contract)
        |> Repo.preload(:sales)
      assert {:error, %Ecto.Changeset{}} = Vouchers.update_voucher(voucher, @invalid_attrs)
      assert {:ok, voucher_p} == Vouchers.get_voucher!(voucher.id)
    end

    test "delete_voucher/1 deletes the voucher" do
      voucher = voucher_fixture()
      assert {:ok, %Voucher{}} = Vouchers.delete_voucher(voucher)
      assert_raise Ecto.NoResultsError, fn -> Vouchers.get_voucher!(voucher.id) end
    end

    test "change_voucher/1 returns a voucher changeset" do
      voucher = voucher_fixture()
      assert %Ecto.Changeset{} = Vouchers.change_voucher(voucher)
    end


    test "get_vouchers_by_contract/1 returns vouchers" do
      voucher = voucher_fixture()
      assert Vouchers.get_vouchers_by_contract!(voucher.contract_id) == [voucher]
    end

    test "get_voucher_by_code_and_brand_hostname/1 returns vouchers" do
      voucher = voucher_fixture()
      voucher_p =
        Repo.preload(voucher, [{:contract, :brand}])
      assert Vouchers.get_voucher_by_code_and_brand_hostname("some code", "some hostname") == voucher_p
    end

    test "get_total_voucher_revenue/1 returns correct result" do
      voucher = voucher_fixture()
      assert Vouchers.get_total_voucher_revenue(voucher.id) == Decimal.new(0)
    end

    test "get_number_of_sales/1 returns correct result" do
      voucher = voucher_fixture()
      assert Vouchers.get_number_of_sales(voucher.id) == 0
    end

    test "get_voucher_customers/1 returns correct result" do
      voucher = voucher_fixture()
      assert Vouchers.get_voucher_customers(voucher.id) == []
    end

    test "get_sales_countries/1 returns correct result" do
      voucher = voucher_fixture()
      assert Vouchers.get_sales_countries(voucher.id) == []
    end

    test "add_sale/1 returns correct result" do
      voucher = voucher_fixture()
      assert {:ok, voucher} = Vouchers.add_sale(voucher, 3)

      assert voucher.sales_counter == 1
    end

    test "add_view/1 returns correct result" do
      voucher = voucher_fixture()
      assert {:ok, voucher} = Vouchers.add_view(voucher)

      assert voucher.views_counter == 1
    end



  end
end
