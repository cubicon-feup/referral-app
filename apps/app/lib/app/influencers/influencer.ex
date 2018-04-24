defmodule App.Influencers.Influencer do
  use Ecto.Schema
  import Ecto.Changeset


  schema "influencers" do
    field :address, :string
    field :code, :string
    field :name, :string
    field :nib, :integer
    field :user_id, :id
    field :contact, :string

    timestamps()
  end

  @doc false
  def changeset(influencer, attrs) do
    influencer
    |> cast(attrs, [:name, :address, :nib, :code, :contact])
    |> validate_required([:name, :contact])
  end
end
