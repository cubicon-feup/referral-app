defmodule App.VouchersTest do
  use App.DataCase

  alias App.Vouchers

  describe "vouchers" do
    alias App.Vouchers.Voucher

    @valid_attrs %{amount: "120.5", comulative_with_sales: true, comulative_with_vouchers: true, expiration_date: ~N[2010-04-17 14:00:00.000000], free_shipping: true, maximum_spent_to_use: "120.5", minimum_spent_to_use: "120.5", uses: 42, uses_per_person: 42}
    @update_attrs %{amount: "456.7", comulative_with_sales: false, comulative_with_vouchers: false, expiration_date: ~N[2011-05-18 15:01:01.000000], free_shipping: false, maximum_spent_to_use: "456.7", minimum_spent_to_use: "456.7", uses: 43, uses_per_person: 43}
    @invalid_attrs %{amount: nil, comulative_with_sales: nil, comulative_with_vouchers: nil, expiration_date: nil, free_shipping: nil, maximum_spent_to_use: nil, minimum_spent_to_use: nil, uses: nil, uses_per_person: nil}

    def voucher_fixture(attrs \\ %{}) do
      {:ok, voucher} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vouchers.create_voucher()

      voucher
    end

    test "list_vouchers/0 returns all vouchers" do
      voucher = voucher_fixture()
      assert Vouchers.list_vouchers() == [voucher]
    end

    test "get_voucher!/1 returns the voucher with given id" do
      voucher = voucher_fixture()
      assert Vouchers.get_voucher!(voucher.id) == voucher
    end

    test "create_voucher/1 with valid data creates a voucher" do
      assert {:ok, %Voucher{} = voucher} = Vouchers.create_voucher(@valid_attrs)
      assert voucher.amount == Decimal.new("120.5")
      assert voucher.comulative_with_sales == true
      assert voucher.comulative_with_vouchers == true
      assert voucher.expiration_date == ~N[2010-04-17 14:00:00.000000]
      assert voucher.free_shipping == true
      assert voucher.maximum_spent_to_use == Decimal.new("120.5")
      assert voucher.minimum_spent_to_use == Decimal.new("120.5")
      assert voucher.uses == 42
      assert voucher.uses_per_person == 42
    end

    test "create_voucher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vouchers.create_voucher(@invalid_attrs)
    end

    test "update_voucher/2 with valid data updates the voucher" do
      voucher = voucher_fixture()
      assert {:ok, voucher} = Vouchers.update_voucher(voucher, @update_attrs)
      assert %Voucher{} = voucher
      assert voucher.amount == Decimal.new("456.7")
      assert voucher.comulative_with_sales == false
      assert voucher.comulative_with_vouchers == false
      assert voucher.expiration_date == ~N[2011-05-18 15:01:01.000000]
      assert voucher.free_shipping == false
      assert voucher.maximum_spent_to_use == Decimal.new("456.7")
      assert voucher.minimum_spent_to_use == Decimal.new("456.7")
      assert voucher.uses == 43
      assert voucher.uses_per_person == 43
    end

    test "update_voucher/2 with invalid data returns error changeset" do
      voucher = voucher_fixture()
      assert {:error, %Ecto.Changeset{}} = Vouchers.update_voucher(voucher, @invalid_attrs)
      assert voucher == Vouchers.get_voucher!(voucher.id)
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
  end

  describe "vouchers" do
    alias App.Vouchers.Voucher

    @valid_attrs %{code: "some code"}
    @update_attrs %{code: "some updated code"}
    @invalid_attrs %{code: nil}

    def voucher_fixture(attrs \\ %{}) do
      {:ok, voucher} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vouchers.create_voucher()

      voucher
    end

    test "list_vouchers/0 returns all vouchers" do
      voucher = voucher_fixture()
      assert Vouchers.list_vouchers() == [voucher]
    end

    test "get_voucher!/1 returns the voucher with given id" do
      voucher = voucher_fixture()
      assert Vouchers.get_voucher!(voucher.id) == voucher
    end

    test "create_voucher/1 with valid data creates a voucher" do
      assert {:ok, %Voucher{} = voucher} = Vouchers.create_voucher(@valid_attrs)
      assert voucher.code == "some code"
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
      assert {:error, %Ecto.Changeset{}} = Vouchers.update_voucher(voucher, @invalid_attrs)
      assert voucher == Vouchers.get_voucher!(voucher.id)
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
  end
end
