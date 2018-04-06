defmodule AppWeb.ContractView do
  use AppWeb, :view
  alias AppWeb.ContractView

  def render("index.json", %{contracts: contracts}) do
    %{data: render_many(contracts, ContractView, "contract.json")}
  end

  def render("show.json", %{contract: contract}) do
    %{data: render_one(contract, ContractView, "contract.json")}
  end

  def render("contract.json", %{contract: contract}) do
    %{id: contract.id,
      static_amount_on_sales: contract.static_amount_on_sales,
      percent_amount_on_sales: contract.percent_amount_on_sales,
      static_amount_on_set_of_sales: contract.static_amount_on_set_of_sales,
      size_of_set_of_sales: contract.size_of_set_of_sales,
      static_amount_on_views: contract.static_amount_on_views,
      number_of_views: contract.number_of_views,
      minimum_amount_of_sales: contract.minimum_amount_of_sales,
      minimum_amout_of_views: contract.minimum_amout_of_views,
      minimum_sales: contract.minimum_sales,
      time_between_payments: contract.time_between_payments,
      current_amount: contract.current_amount,
      is_requestable: contract.is_requestable,
      send_notification_to_influencer: contract.send_notification_to_influencer,
      send_notification_to_brand: contract.send_notification_to_brand}
  end
end
