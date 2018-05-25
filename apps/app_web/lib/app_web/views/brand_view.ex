defmodule AppWeb.BrandView do
  use AppWeb, :view

  alias App.Contracts

  def get_influencer_revenue(contract_id) do
    Contracts.get_total_contract_revenue(contract_id)
  end
end
