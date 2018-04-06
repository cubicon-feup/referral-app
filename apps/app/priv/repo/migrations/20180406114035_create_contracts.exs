defmodule App.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :static_amount_on_sales, :decimal
      add :percent_amount_on_sales, :decimal
      add :static_amount_on_set_of_sales, :decimal
      add :size_of_set_of_sales, :integer
      add :static_amount_on_views, :decimal
      add :number_of_views, :integer
      add :minimum_amount_of_sales, :decimal
      add :minimum_amout_of_views, :integer
      add :minimum_sales, :decimal
      add :time_between_payments, :integer
      add :current_amount, :decimal
      add :is_requestable, :boolean, default: false, null: false
      add :send_notification_to_influencer, :boolean, default: false, null: false
      add :send_notification_to_brand, :boolean, default: false, null: false
      add :influencer_id, references(:influencer, on_delete: :nothing)
      add :brand_id, references(:brand, on_delete: :nothing)

      timestamps()
    end

    create index(:contracts, [:influencer_id])
    create index(:contracts, [:brand_id])
  end
end
