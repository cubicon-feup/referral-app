defmodule AppWeb.Api.RuleView do
  use AppWeb, :view
  alias AppWeb.Api.RuleView

  def render("index.json", %{rules: rules}) do
    %{data: render_many(rules, RuleView, "rule.json")}
  end

  def render("show.json", %{rule: rule}) do
    %{data: render_one(rule, RuleView, "rule.json")}
  end

  def render("rule.json", %{rule: rule}) do
    %{id: rule.id,
      contract_id: rule.contract_id,
      sales_counter: rule.sales_counter,
      set_of_sales: rule.set_of_sales,
      percent_on_sales: rule.percent_on_sales,
      points_on_sales: rule.points_on_sales,
      views_counter: rule.views_counter,
      set_of_views: rule.set_of_views,
      points_on_views: rule.points_on_views,
      points_per_month: rule.points_per_month}
  end
end
