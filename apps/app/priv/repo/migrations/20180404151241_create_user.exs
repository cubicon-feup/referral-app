defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :date_of_birth, :date, null: false
      add :email, :string, null: false
      add :name, :string, null: false
      add :password, :string, null: false
      add :picture_path, :string, null: false
      add :priveleges_level, :string, null: false
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:user, [:email])
  end
end
