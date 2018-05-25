defmodule AppWeb.BrandView do
  use AppWeb, :view

  alias App.Contracts

  def get_influencer_revenue(contract_id) do
    Contracts.get_total_contract_revenue(contract_id)
  end

  def get_influencer_pending_payments(contract_id) do
    Contracts.get_contract_pending_payments(contract_id)
  end

  def get_influencer_voucher_views(contract_id) do
    Contracts.get_total_contract_views(contract_id)
  end

  def get_number_of_influencer_sales(contract_id) do
    Contracts.get_number_of_sales(contract_id)
  end
end
