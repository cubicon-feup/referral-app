defmodule App.Vouchers.Voucher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vouchers" do
    field :code, :string
    belongs_to :rule, App.Rules.Rule

    timestamps()
  end

  @doc false
  def changeset(voucher, attrs) do
    voucher
    |> cast(attrs, [:code])
    |> cast_assoc(:rule)
    |> validate_required([:code])
  end
end
