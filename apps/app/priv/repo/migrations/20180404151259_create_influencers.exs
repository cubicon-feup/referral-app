defmodule App.Repo.Migrations.CreateInfluencers do
  use Ecto.Migration

  def change do
    create table(:influencer) do
      add :name, :string, null: false
      add :address, :string, null: false
      add :nib, :integer, null: false
      add :code, :string, null: false
      add :influencer_id, references(:user, on_delete: :nothing), null: false

      timestamps()
    end

  end
end
