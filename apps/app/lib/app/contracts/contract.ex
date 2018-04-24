defmodule App.Contracts.Contract do
  use Ecto.Schema
  import Ecto.Changeset



  schema "contracts" do
    field :current_amount, :decimal
    field :is_requestable, :boolean, default: false
    field :minimum_amount_of_sales, :decimal
    field :minimum_amout_of_views, :integer
    field :minimum_sales, :decimal
    field :number_of_views, :integer
    field :percent_amount_on_sales, :decimal
    field :send_notification_to_brand, :boolean, default: false
    field :send_notification_to_influencer, :boolean, default: false
    field :size_of_set_of_sales, :integer
    field :static_amount_on_sales, :decimal
    field :static_amount_on_set_of_sales, :decimal
    field :static_amount_on_views, :decimal
    field :time_between_payments, :integer
    field :influencer_id, :id
    belongs_to :brand, App.Brands.Brand
    has_one :voucher, App.Vouchers.Voucher

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:static_amount_on_sales, :percent_amount_on_sales, :static_amount_on_set_of_sales, :size_of_set_of_sales, :static_amount_on_views, :number_of_views, :minimum_amount_of_sales, :minimum_amout_of_views, :minimum_sales, :time_between_payments, :current_amount, :is_requestable, :send_notification_to_influencer, :send_notification_to_brand, :brand_id])
    |> cast_assoc(:brand)
    |> validate_required([:static_amount_on_sales, :percent_amount_on_sales, :static_amount_on_set_of_sales, :size_of_set_of_sales, :static_amount_on_views, :number_of_views, :minimum_amount_of_sales, :minimum_amout_of_views, :minimum_sales, :time_between_payments, :current_amount, :is_requestable, :send_notification_to_influencer, :send_notification_to_brand])
  end
end
