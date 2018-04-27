defmodule App.Rules.Rule do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rules" do
    belongs_to :contract, App.Contracts.Contract
    field :percent_on_sales, :decimal, default: 0
    field :points_on_sales, :integer, default: 0
    field :points_on_views, :integer, default: 0
    field :points_per_month, :integer, default: 0
    field :sales_counter, :integer, default: 0
    field :set_of_sales, :integer, default: 0
    field :set_of_views, :integer, default: 0
    field :views_counter, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(rule, attrs) do
    rule
    |> cast(attrs, [:contract_id, :sales_counter, :set_of_sales, :percent_on_sales, :points_on_sales, :views_counter, :set_of_views, :points_on_views, :points_per_month])
    |> cast_assoc(:contract)
    |> validate_required([:contract_id])
  end
end
