defmodule App.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :shortcode, :string
      add :voucher_id, references(:vouchers, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:links, [:user_id])
    create index(:links, [:voucher_id])
  end
end
