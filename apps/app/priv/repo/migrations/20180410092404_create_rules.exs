defmodule App.Repo.Migrations.CreateRules do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :contract_id, references(:contracts, on_delete: :nothing)
      add :sales_counter, :integer
      add :set_of_sales, :integer
      add :percent_on_sales, :decimal
      add :points_on_sales, :decimal
      add :views_counter, :integer
      add :set_of_views, :integer
      add :points_on_views, :decimal
      add :points_per_month, :decimal

      timestamps()
    end

  end
end
