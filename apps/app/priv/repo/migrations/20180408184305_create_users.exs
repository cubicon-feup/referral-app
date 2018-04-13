defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :date_of_birth, :date
      add :deleted, :boolean, default: false, null: false
      add :email, :string
      add :name, :string
      add :password, :string
      add :picture_path, :string
      add :priveleges_level, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
