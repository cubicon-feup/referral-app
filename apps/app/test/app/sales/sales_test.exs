defmodule App.SalesTest do
  use App.DataCase

  alias App.Sales

  describe "sales" do
    alias App.Sales.Sale
    # alias App.Influencers
    # alias App.Brands
    # alias App.Vouchers
    # alias App.Contracts
    #
    # @valid_attrs_influencer %{address: "some address", name: "some name", nib: 42}
    # @valid_attrs_brand %{
    #   api_key: "some api_key",
    #   api_password: "some api_password",
    #   hostname: "some hostname",
    #   name: "some name"
    # }
    # @valid_attrs_contract %{minimum_points: 42, payment_period: 42, points: 42}
    #
    # @valid_attrs %{date: ~N[2010-04-17 14:00:00.000000], value: "120.5", voucher_id: 1}
    # @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], value: "456.7", voucher_id: 1}
    # @invalid_attrs %{date: nil, value: nil, voucher_id: nil}
    #
    # def voucher_fixture() do
    #   {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)
    #   {:ok, brand} = Brands.create_brand(@valid_attrs_brand)
    #
    #   {:ok, contract} =
    #     attrs
    #     |> Enum.into(%{influencer_id: influencer.id, brand_id: brand.id})
    #     |> Enum.into(@valid_attrs)
    #     |> Contracts.create_contract()
    #
    #   {:ok, voucher} = Vouchers.create_voucher(@valid_attrs_voucher)
    #
    #   voucher
    # end
    #
    # def sale_fixture(attrs \\ %{}) do
    #   {:ok, sale} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Sales.create_sale()
    #
    #   sale
    # end
    #
    # test "list_sales/0 returns all sales" do
    #   sale = sale_fixture()
    #   assert Sales.list_sales() == [sale]
    # end
    #
    # test "get_sale!/1 returns the sale with given id" do
    #   sale = sale_fixture()
    #   assert Sales.get_sale!(sale.id) == sale
    # end
    #
    # test "create_sale/1 with valid data creates a sale" do
    #   assert {:ok, %Sale{} = sale} = Sales.create_sale(@valid_attrs)
    #   assert sale.date == ~N[2010-04-17 14:00:00.000000]
    #   assert sale.value == Decimal.new("120.5")
    # end
    #
    # test "create_sale/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Sales.create_sale(@invalid_attrs)
    # end
    #
    # test "update_sale/2 with valid data updates the sale" do
    #   sale = sale_fixture()
    #   assert {:ok, sale} = Sales.update_sale(sale, @update_attrs)
    #   assert %Sale{} = sale
    #   assert sale.date == ~N[2011-05-18 15:01:01.000000]
    #   assert sale.value == Decimal.new("456.7")
    # end
    #
    # test "update_sale/2 with invalid data returns error changeset" do
    #   sale = sale_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Sales.update_sale(sale, @invalid_attrs)
    #   assert sale == Sales.get_sale!(sale.id)
    # end
    #
    # test "delete_sale/1 deletes the sale" do
    #   sale = sale_fixture()
    #   assert {:ok, %Sale{}} = Sales.delete_sale(sale)
    #   assert_raise Ecto.NoResultsError, fn -> Sales.get_sale!(sale.id) end
    # end
    #
    # test "change_sale/1 returns a sale changeset" do
    #   sale = sale_fixture()
    #   assert %Ecto.Changeset{} = Sales.change_sale(sale)
    # end
  end
end
