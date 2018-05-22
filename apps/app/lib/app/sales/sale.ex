defmodule App.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field(:date, :naive_datetime)
    field(:value, :decimal)
    field(:voucher_id, :id)
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
      :voucher_id,
      :customer_locale,
      :total_discounts,
      :customer_id,
      :date_sale
    ])
    |> foreign_key_constraint(:voucher_id)
    |> validate_required([:date, :value, :voucher_id])
  end
end
