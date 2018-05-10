defmodule App.Influencers.Influencer do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Contracts.Contract

  schema "influencers" do
    field :contact, :string
    field :address, :string
    field :name, :string
    field :nib, :integer
    field :user_id, :id
    has_one(:contract, App.Contracts.Contract)
    

    timestamps()
  end

  @doc false
  def changeset(influencer, attrs) do
    influencer
    |> cast(attrs, [:name, :address, :nib, :user_id, :contact])
    |> cast_assoc(:contract, required: true, with: &Contract.changeset/2)
    |> validate_required([:name, :contact])
  end
end
