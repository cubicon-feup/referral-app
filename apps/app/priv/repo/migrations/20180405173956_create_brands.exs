defmodule App.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string
      add :hostname, :string
      add :api_key, :string
      add :api_password, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:brands, [:user_id])
    
  end
end
