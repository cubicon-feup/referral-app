defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :date_of_birth, :date
      add :email, :string
      add :name, :string
      add :password, :string
      add :picture_path, :string
      add :privileges_level, :string
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
