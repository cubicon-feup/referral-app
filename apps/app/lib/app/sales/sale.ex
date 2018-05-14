defmodule App.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field(:date, :naive_datetime)
    field(:value, :decimal)
    field(:voucher_id, :id)

    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [:date, :value, :voucher_id])
    |> foreign_key_constraint(:voucher_id)
    |> validate_required([:date, :value, :voucher_id])
  end
end
