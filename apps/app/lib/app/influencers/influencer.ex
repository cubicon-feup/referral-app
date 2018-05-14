defmodule App.Influencers.Influencer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "influencers" do
    field :contact, :string
    field :address, :string
    field :name, :string
    field :nib, :integer
    field :user_id, :id

    field :payment_period, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(influencer, attrs) do
    influencer
    |> cast(attrs, [:name, :address, :nib, :user_id, :contact])
    |> validate_required([:name, :contact])
  end
end
