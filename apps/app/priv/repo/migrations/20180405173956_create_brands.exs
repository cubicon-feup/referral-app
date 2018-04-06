defmodule App.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brand) do
      add :name, :string
      add :brand_id, references(:user, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:brand, [:name])
  end
end
