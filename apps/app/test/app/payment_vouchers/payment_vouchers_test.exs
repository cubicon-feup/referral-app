defmodule App.Payment_vouchersTest do
  use App.DataCase

  alias App.Payment_vouchers

  describe "payment_voucher" do
    alias App.Payment_vouchers.Payment_voucher

    @valid_attrs %{amount: "120.5", comulative_with_sales: true, comulative_with_vouchers: true, expiration_date: ~N[2010-04-17 14:00:00.000000], maximum_spent_to_use: "120.5", minimum_spent_to_use: "120.5"}
    @update_attrs %{amount: "456.7", comulative_with_sales: false, comulative_with_vouchers: false, expiration_date: ~N[2011-05-18 15:01:01.000000], maximum_spent_to_use: "456.7", minimum_spent_to_use: "456.7"}
    @invalid_attrs %{amount: nil, comulative_with_sales: nil, comulative_with_vouchers: nil, expiration_date: nil, maximum_spent_to_use: nil, minimum_spent_to_use: nil}

    def payment_voucher_fixture(attrs \\ %{}) do
      {:ok, payment_voucher} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payment_vouchers.create_payment_voucher()

      payment_voucher
    end

    test "list_payment_voucher/0 returns all payment_voucher" do
      payment_voucher = payment_voucher_fixture()
      assert Payment_vouchers.list_payment_voucher() == [payment_voucher]
    end

    test "get_payment_voucher!/1 returns the payment_voucher with given id" do
      payment_voucher = payment_voucher_fixture()
      assert Payment_vouchers.get_payment_voucher!(payment_voucher.id) == payment_voucher
    end

    test "create_payment_voucher/1 with valid data creates a payment_voucher" do
      assert {:ok, %Payment_voucher{} = payment_voucher} = Payment_vouchers.create_payment_voucher(@valid_attrs)
      assert payment_voucher.amount == Decimal.new("120.5")
      assert payment_voucher.comulative_with_sales == true
      assert payment_voucher.comulative_with_vouchers == true
      assert payment_voucher.expiration_date == ~N[2010-04-17 14:00:00.000000]
      assert payment_voucher.maximum_spent_to_use == Decimal.new("120.5")
      assert payment_voucher.minimum_spent_to_use == Decimal.new("120.5")
    end

    test "create_payment_voucher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payment_vouchers.create_payment_voucher(@invalid_attrs)
    end

    test "update_payment_voucher/2 with valid data updates the payment_voucher" do
      payment_voucher = payment_voucher_fixture()
      assert {:ok, payment_voucher} = Payment_vouchers.update_payment_voucher(payment_voucher, @update_attrs)
      assert %Payment_voucher{} = payment_voucher
      assert payment_voucher.amount == Decimal.new("456.7")
      assert payment_voucher.comulative_with_sales == false
      assert payment_voucher.comulative_with_vouchers == false
      assert payment_voucher.expiration_date == ~N[2011-05-18 15:01:01.000000]
      assert payment_voucher.maximum_spent_to_use == Decimal.new("456.7")
      assert payment_voucher.minimum_spent_to_use == Decimal.new("456.7")
    end

    test "update_payment_voucher/2 with invalid data returns error changeset" do
      payment_voucher = payment_voucher_fixture()
      assert {:error, %Ecto.Changeset{}} = Payment_vouchers.update_payment_voucher(payment_voucher, @invalid_attrs)
      assert payment_voucher == Payment_vouchers.get_payment_voucher!(payment_voucher.id)
    end

    test "delete_payment_voucher/1 deletes the payment_voucher" do
      payment_voucher = payment_voucher_fixture()
      assert {:ok, %Payment_voucher{}} = Payment_vouchers.delete_payment_voucher(payment_voucher)
      assert_raise Ecto.NoResultsError, fn -> Payment_vouchers.get_payment_voucher!(payment_voucher.id) end
    end

    test "change_payment_voucher/1 returns a payment_voucher changeset" do
      payment_voucher = payment_voucher_fixture()
      assert %Ecto.Changeset{} = Payment_vouchers.change_payment_voucher(payment_voucher)
    end
  end
end
