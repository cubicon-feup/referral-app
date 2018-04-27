defmodule App.Contracts.Contract do
  use Ecto.Schema
  import Ecto.Changeset


  schema "contracts" do
    belongs_to :brand, App.Brands.Brand
    belongs_to :influencer, App.Influencers.Influencer
    field :minimum_points, :integer, default: 0
    field :payment_period, :integer, default: 0
    field :points, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:influencer_id, :brand_id, :minimum_points, :payment_period, :points])
    |> cast_assoc(:brand)
    |> cast_assoc(:influencer)
    |> validate_required([:influencer_id, :brand_id])
    |> unique_constraint(:unique_index_brand_influencer, name: :index_brand_influencer)
  end
end
