defmodule App.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field(:date, :naive_datetime)
    field(:value, :decimal)
    field(:contract_id, :id)

    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [:date, :value, :contract_id])
    |> validate_required([:date, :value, :contract_id])
    |> foreign_key_constraint(:contract_id)
  end
end
