defmodule App.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string
      add :user_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:brands, [:name])
    create index(:brands, [:user_id])
  end
end
