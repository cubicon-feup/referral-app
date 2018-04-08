defmodule App.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sale" do
    field :date, :naive_datetime
    field :value, :decimal
    field :contract_id, :id

    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [:date, :value])
    |> validate_required([:date, :value])
  end
end
