defmodule App.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brand) do
      add :name, :string, null: false
      add :brand_id, references(:user, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:brand, [:name])
  end
end
