defmodule AppWeb.PaymentView do
  use AppWeb, :view

  alias App.Influencers

  def get_influencer(influencer_id) do
    Influencers.get_influencer!(influencer_id)
  end
  
end
