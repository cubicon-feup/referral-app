defmodule App.Vouchers.Voucher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vouchers" do
    belongs_to(:contract, App.Contracts.Contract)
    field(:code, :string)
    field(:percent_on_sales, :decimal, default: 0.1)
    field(:points_on_sales, :decimal, default: 0.0)
    field(:points_on_views, :decimal, default: 0.0)
    field(:points_per_month, :decimal, default: 0.0)
    field(:sales_counter, :integer, default: 0)
    field(:set_of_sales, :integer, default: 1)
    field(:set_of_views, :integer, default: 1)
    field(:views_counter, :integer, default: 0)

    timestamps()
  end

  @doc false
  def changeset(voucher, attrs) do
    voucher
    |> cast(attrs, [
      :code,
      :contract_id,
      :sales_counter,
      :set_of_sales,
      :percent_on_sales,
      :points_on_sales,
      :views_counter,
      :set_of_views,
      :points_on_views,
      :points_per_month
    ])
    |> cast_assoc(:contract)
    |> validate_required([:code, :contract_id])
  end
end
