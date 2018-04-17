defmodule AppWeb.Api.PlanView do
  use AppWeb, :view
  alias AppWeb.Api.PlanView

  def render("index.json", %{plans: plans}) do
    %{data: render_many(plans, PlanView, "plan.json")}
  end

  def render("show.json", %{plan: plan}) do
    %{data: render_one(plan, PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    %{id: plan.id,
      name: plan.name,
      max_influencers: plan.max_influencers}
  end
end
