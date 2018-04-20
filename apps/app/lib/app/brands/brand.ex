defmodule App.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset


  schema "brands" do
    field :api_key, :string
    field :api_password, :string
    field :hostname, :string
    field :name, :string
    field :user_id, :id
    has_many :contracts, App.Contracts.Contract

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :hostname, :api_key, :api_password])
    |> validate_required([:name, :hostname, :api_key, :api_password])
  end
end
