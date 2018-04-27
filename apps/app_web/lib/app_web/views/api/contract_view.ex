defmodule AppWeb.Api.ContractView do
  use AppWeb, :view
  alias AppWeb.Api.ContractView

  def render("index.json", %{contracts: contracts}) do
    %{data: render_many(contracts, ContractView, "contract.json")}
  end

  def render("show.json", %{contract: contract}) do
    %{data: render_one(contract, ContractView, "contract.json")}
  end

  def render("contract.json", %{contract: contract}) do
    %{id: contract.id,
      influencer_id: contract.influencer_id,
      brand_id: contract.brand_id,
      minimum_points: contract.minimum_points,
      payment_period: contract.payment_period,
      points: contract.points}
  end
end
