defmodule App.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field :date, :naive_datetime
    field :value, :decimal
    belongs_to :voucher, App.Vouchers.Voucher

    timestamps()
  end

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, [:date, :value])
    |> cast_assoc(:voucher)
    |> validate_required([:date, :value])
  end
end
