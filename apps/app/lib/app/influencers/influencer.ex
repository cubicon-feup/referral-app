defmodule App.Influencers.Influencer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "influencers" do
    field :address, :string
    field :name, :string
    field :nib, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(influencer, attrs) do
    influencer
    |> cast(attrs, [:name, :address, :nib])
    |> validate_required([:name])
  end
end
