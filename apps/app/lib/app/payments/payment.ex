defmodule App.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :status, :string, default: "pending"
    field :request_date, :naive_datetime
    field :payment_date, :naive_datetime
    field :type, :string
    field :description, :string
    field :value, :decimal
    field :brand_id, :id
    belongs_to :influencer, App.Influencers.Influencer

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:request_date, :payment_date, :type, :status, :value, :description, :influencer_id])
    |> cast_assoc(:influencer)
    |> validate_required([:influencer_id, :type, :value])
    |> validate_inclusion(:status, ["pending", "complete", "cancelled"])
    |> validate_inclusion(:type, ["money", "voucher", "products"])
  end
end
