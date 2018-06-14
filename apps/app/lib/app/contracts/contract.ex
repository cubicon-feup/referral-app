defmodule App.Contracts.Contract do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contracts" do
    belongs_to(:brand, App.Brands.Brand)
    field(:minimum_points, :integer, default: 0)
    field(:payment_period, :integer, default: 0)
    field(:points, :decimal, default: Decimal.new("0.0"))
    field(:points, :decimal, default: Decimal.new("0.00"))
    has_many(:voucher, App.Vouchers.Voucher)
    has_many(:payments, App.Payments.Payment)
    field :email, :string
    field :address, :string
    field :name, :string
    field :nib, :integer
    belongs_to(:user, App.Users.User)

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:brand_id, :minimum_points, :payment_period, :points, :email, :address, :name, :nib, :user_id])
    |> cast_assoc(:brand)
    |> cast_assoc(:user)
    |> validate_required([:brand_id])
  end
end
