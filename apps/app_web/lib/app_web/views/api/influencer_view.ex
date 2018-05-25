defmodule AppWeb.Api.InfluencerView do
  use AppWeb, :view
  alias AppWeb.Api.InfluencerView

  def render("index.json", %{influencers: influencers}) do
    %{data: render_many(influencers, InfluencerView, "influencer.json")}
  end

  def render("show.json", %{influencer: influencer}) do
    %{data: render_one(influencer, InfluencerView, "influencer.json")}
  end

  def render("influencer.json", %{influencer: influencer}) do
    %{id: influencer.id,
      name: influencer.name,
      address: influencer.address,
      nib: influencer.nib}
  end
end
