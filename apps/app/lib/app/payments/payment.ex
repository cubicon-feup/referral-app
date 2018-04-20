defmodule App.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payments" do
    field :paid, :boolean, default: false
    field :request_date, :naive_datetime
    field :value, :decimal
    field :brand_id, :id
    field :influencer_id, :id

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:request_date, :paid, :value])
    |> validate_required([:request_date, :paid, :value])
  end
end
