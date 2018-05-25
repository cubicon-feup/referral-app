defmodule App.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    belongs_to(:voucher, App.Vouchers.Voucher)
    field(:date, :naive_datetime)
    field(:value, :decimal)
    field(:customer_locale, :string)
    field(:total_discounts, :decimal)
    field(:customer_id, :integer)
    field(:date_sale, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [
      :date,
      :value,
      :customer_locale,
      :total_discounts,
      :customer_id,
      :date_sale
    ])
    |> cast_assoc(:voucher)
    |> validate_required([:date, :value])
  end
end
