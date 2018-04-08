defmodule App.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset


  schema "brand" do
    field :name, :string
    field :brand_id, :id
    field :hostname, :string
    field :api_key, :string
    field :api_password, :string

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :hostname, :api_key, :api_password])
    |> validate_required([:name, :hostname, :api_key, :api_password])
    |> unique_constraint(:name)
  end
end
