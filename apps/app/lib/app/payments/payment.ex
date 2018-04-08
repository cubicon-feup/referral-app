defmodule App.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment" do
    field :paid, :boolean, default: false
    field :requestDate, :naive_datetime
    field :value, :decimal
    field :influencer_id, :id
    field :brand_id, :id

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:requestDate, :paid, :value])
    |> validate_required([:requestDate, :paid, :value])
  end
end
