defmodule App.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field(:api_key, :string)
    field(:api_password, :string)
    field(:hostname, :string)
    field(:name, :string)
    field(:user_id, :id)
    field :picture_path, :string  
    has_many(:contracts, App.Contracts.Contract)

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :hostname, :api_key, :api_password, :user_id])
    |> validate_required([:name, :hostname, :api_key, :api_password])
    |> foreign_key_constraint(:user_id)
  end
end
