defmodule App.Plans.Plan do
  use Ecto.Schema
  import Ecto.Changeset


  schema "plan" do
    field :max_influencers, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name, :max_influencers])
    |> validate_required([:name, :max_influencers])
  end
end
