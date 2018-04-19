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
    field :privileges_level, :string, default: "user"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:date_of_birth, :deleted, :email, :name, :password, :picture_path, :privileges_level])
    |> validate_required([:date_of_birth, :deleted, :email, :name, :password, :picture_path, :privileges_level])
    |> validate_inclusion(:privileges_level, ["user", "admin", "banned"])
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end
  defp put_pass_hash(changeset), do: changeset

end
