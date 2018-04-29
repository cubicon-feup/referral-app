defmodule App.Price_rules.Price_rule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "price_rule" do
    field(:code, :string)
    field(:value_type, :string)
    field(:value, :decimal)
    field(:customer_selection, :string)
    field(:target_type, :string)
    field(:target_selection, :string)
    field(:allocation_method, :string)
    field(:once_per_customer, :boolean)
    field(:usage_limit, :integer)
    field(:starts_at, :naive_datetime)
    field(:ends_at, :naive_datetime)
    field(:created_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:entitled_collection_ids, {:array, :integer})
    field(:entitled_country_ids, {:array, :integer})
    field(:prerequisite_subtotal_range, :decimal)
    field(:prerequisite_shipping_price_range, :decimal)
    field(:title, :string)
  end

  @doc false
  def changeset(price_rule, attrs) do
    price_rule
    |> cast(attrs, [
      :code,
      :value_type,
      :value,
      :customer_selection,
      :target_type,
      :target_selection,
      :allocation_method,
      :once_per_customer,
      :usage_limit,
      :starts_at,
      :ends_at,
      :updated_at,
      :entitled_collections_ids,
      :title
    ])
    |> validate_required([:code])
  end
end
