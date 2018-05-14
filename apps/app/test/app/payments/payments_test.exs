defmodule App.PaymentsTest do
  use App.DataCase

  alias App.Payments
  alias App.Influencers
  alias App.Brands

  describe "payments" do
    alias App.Payments.Payment

    @valid_attrs %{type: "voucher", value: "120.5"}
    @update_attrs %{type: "money", value: "456.7", status: "complete"}
    @invalid_attrs %{influencer_id: nil, type: nil, value: nil}

    @valid_attrs_influencer %{address: "some address", name: "some name", nib: 42, contact: "some contact"}
    @valid_attrs_brand %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}

    def influencer_fixture() do
      {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)

      influencer
    end

    def brand_fixture() do
      {:ok, brand} = Brands.create_brand(@valid_attrs_brand)

      brand
    end

    def payment_fixture(attrs \\ %{}) do
      influencer = influencer_fixture()
      brand = brand_fixture()

      {:ok, payment} =
        attrs
        |> Enum.into(%{brand_id: brand.id, influencer_id: influencer.id})
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment()

      Payments.get_payment!(payment.id)
    end

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Payments.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Payments.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      influencer = influencer_fixture()
      brand = brand_fixture()
      assert {:ok, %Payment{} = payment} =
        Enum.into(%{brand_id: brand.id, influencer_id: influencer.id}, @valid_attrs)
        |> Payments.create_payment()
      assert payment.type == "voucher"
      assert payment.value == Decimal.new("120.5")
    end

    test "create_payment/1 with invalid data returns error changeset" do
      #influencer = influencer_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      assert {:ok, payment} = Payments.update_payment(payment, @update_attrs)
      assert %Payment{} = payment
      assert payment.type == "money"
      assert payment.value == Decimal.new("456.7")
      assert payment.status == "complete"
      assert payment.payment_date != nil
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment(payment, @invalid_attrs)
      assert payment == Payments.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment(payment)
    end
  end
end
