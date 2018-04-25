defmodule App.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :shortcode, :string
      add :influencer_id, references(:influencers, on_delete: :nothing)

      timestamps()
    end

    create index(:links, [:influencer_id])
  end
end
