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
    belongs_to :brand, App.Brands.Brand
    belongs_to :influencer, App.Influencers.Influencer

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:request_date, :payment_date, :type, :status, :value, :description, :brand_id, :influencer_id])
    |> cast_assoc(:influencer)
    |> cast_assoc(:brand)
    |> validate_required([:brand_id, :influencer_id, :type, :value])
    |> validate_inclusion(:status, ["pending", "complete", "cancelled"])
    |> validate_inclusion(:type, ["money", "voucher", "products"])
    |> check_payment_date(:status)
  end

   @doc false
   defp check_payment_date(payment, status) do
    if Map.has_key?(payment.changes, :status) and payment.changes.status == "complete" do
      change(payment, payment_date: Ecto.DateTime.utc(:usec))
    else
      payment
    end
  end
end
