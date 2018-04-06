defmodule App.Vouchers.Voucher do
  use Ecto.Schema
  import Ecto.Changeset


  schema "vouchers" do
    field :amount, :decimal
    field :comulative_with_sales, :boolean, default: false
    field :comulative_with_vouchers, :boolean, default: false
    field :expiration_date, :naive_datetime
    field :free_shipping, :boolean, default: false
    field :maximum_spent_to_use, :decimal
    field :minimum_spent_to_use, :decimal
    field :uses, :integer
    field :uses_per_person, :integer
    field :contract_id, :id

    timestamps()
  end

  @doc false
  def changeset(voucher, attrs) do
    voucher
    |> cast(attrs, [:amount, :free_shipping, :expiration_date, :minimum_spent_to_use, :maximum_spent_to_use, :comulative_with_vouchers, :comulative_with_sales, :uses_per_person, :uses])
    |> validate_required([:amount, :free_shipping, :expiration_date, :minimum_spent_to_use, :maximum_spent_to_use, :comulative_with_vouchers, :comulative_with_sales, :uses_per_person, :uses])
  end
end
