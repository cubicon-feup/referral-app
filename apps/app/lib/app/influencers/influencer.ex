defmodule App.Influencers.Influencer do
  use Ecto.Schema
  import Ecto.Changeset


  schema "influencer" do
    field :address, :string
    field :code, :string
    field :name, :string
    field :nib, :integer
    field :influencer_id, :id

    timestamps()
  end

  @doc false
  def changeset(influencer, attrs) do
    influencer
    |> cast(attrs, [:name, :address, :nib, :code])
    |> validate_required([:name, :address, :nib, :code])
  end
end
