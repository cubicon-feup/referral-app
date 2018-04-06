defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :date_of_birth, :date
      add :email, :string
      add :name, :string
      add :password, :string
      add :picture_path, :string
      add :priveleges_level, :string
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:user, [:email])
  end
end
