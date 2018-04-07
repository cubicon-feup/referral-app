defmodule App.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contract) do
      add :static_amount_on_sales, :decimal, null: false
      add :percent_amount_on_sales, :decimal, null: false
      add :static_amount_on_set_of_sales, :decimal, null: false
      add :size_of_set_of_sales, :integer, null: false
      add :static_amount_on_views, :decimal, null: false
      add :number_of_views, :integer, null: false
      add :minimum_amount_of_sales, :decimal
      add :minimum_amout_of_views, :integer
      add :minimum_sales, :decimal
      add :time_between_payments, :integer
      add :current_amount, :decimal, null: false
      add :is_requestable, :boolean, default: false, null: false
      add :send_notification_to_influencer, :boolean, default: false, null: false
      add :send_notification_to_brand, :boolean, default: false, null: false
      add :influencer_id, references(:influencer, on_delete: :nothing), null: false
      add :brand_id, references(:brand, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:contract, [:influencer_id])
    create index(:contract, [:brand_id])
  end
end
