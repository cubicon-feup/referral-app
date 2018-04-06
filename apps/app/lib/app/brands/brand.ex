defmodule App.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset


  schema "brand" do
    field :name, :string
    field :brand_id, :id

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
