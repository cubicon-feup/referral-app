defmodule App.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user" do
    field :date_of_birth, :date
    field :deleted, :boolean, default: false
    field :email, :string
    field :name, :string
    field :password, :string
    field :picture_path, :string
    field :priveleges_level, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:date_of_birth, :email, :name, :password, :picture_path, :priveleges_level, :deleted])
    |> validate_required([:date_of_birth, :email, :name, :password, :picture_path, :priveleges_level, :deleted])
    |> unique_constraint([:email])
    |> hash_pass()
  end

  defp hash_pass(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end
  defp hash_pass(changeset), do: changeset
end
