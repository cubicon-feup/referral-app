defmodule App.Repo.Migrations.CreateVouchers do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :code, :string
      add :contract_id, references(:contracts, on_delete: :nothing)
      add :percent_on_sales, :decimal, default: 0
      add :points_on_sales, :decimal, default: 0
      add :points_on_views, :decimal, default: 0
      add :points_per_month, :decimal, default: 0
      add :sales_counter, :integer, default: 0
      add :set_of_sales, :integer, default: 1
      add :set_of_views, :integer, default: 1
      add :views_counter, :integer, default: 0

      timestamps()
    end

    create index(:vouchers, [:contract_id])
  end
end
