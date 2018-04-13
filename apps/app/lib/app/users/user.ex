defmodule App.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :date_of_birth, :date
    field :deleted, :boolean, default: false
    field :email, :string
    field :name, :string
    field :password, :string
    field :picture_path, :string
    field :privileges_level, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:date_of_birth, :email, :name, :password, :picture_path, :privileges_level, :deleted])
    |> validate_required([:date_of_birth, :email, :name, :password, :picture_path, :privileges_level, :deleted])
  end
end
