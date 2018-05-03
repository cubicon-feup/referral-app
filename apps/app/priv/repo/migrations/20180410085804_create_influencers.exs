defmodule App.Repo.Migrations.CreateInfluencers do
  use Ecto.Migration

  def change do
    create table(:influencers) do
      add :name, :string
      add :address, :string
      add :nib, :integer
      add :influencer_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:influencers, [:influencer_id])
  end
end
