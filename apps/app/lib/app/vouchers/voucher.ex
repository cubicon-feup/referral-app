defmodule App.Vouchers.Voucher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vouchers" do
    field(:code, :string)
    belongs_to(:contract, App.Contracts.Contract, foreign_key: :contract_id)

    timestamps()
  end

  @doc false
  def changeset(voucher, attrs) do
    voucher
    |> cast(attrs, [:code, :contract_id])
    |> validate_required([:code])
  end
end
