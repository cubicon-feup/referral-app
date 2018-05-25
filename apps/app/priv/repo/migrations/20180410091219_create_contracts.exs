defmodule App.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add(:brand_id, references(:brands, on_delete: :nothing))
      add(:minimum_points, :integer)
      add(:payment_period, :integer)
      add(:points, :decimal)
      add :name, :string
      add :address, :string
      add :nib, :integer
      add :user_id,  references(:users, on_delete: :nothing)
      add :email, :string

      timestamps()
    end
  end
end
