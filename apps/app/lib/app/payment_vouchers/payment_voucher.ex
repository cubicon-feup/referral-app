defmodule App.Payment_vouchers.Payment_voucher do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_voucher" do
    field :amount, :decimal
    field :comulative_with_sales, :boolean, default: false
    field :comulative_with_vouchers, :boolean, default: false
    field :expiration_date, :naive_datetime
    field :maximum_spent_to_use, :decimal
    field :minimum_spent_to_use, :decimal
    field :payment_id, :id

    timestamps()
  end

  @doc false
  def changeset(payment_voucher, attrs) do
    payment_voucher
    |> cast(attrs, [:amount, :expiration_date, :minimum_spent_to_use, :maximum_spent_to_use, :comulative_with_vouchers, :comulative_with_sales])
    |> validate_required([:amount, :expiration_date, :minimum_spent_to_use, :maximum_spent_to_use, :comulative_with_vouchers, :comulative_with_sales])
    |> unique_constraint([:payment_id])
  end
end
