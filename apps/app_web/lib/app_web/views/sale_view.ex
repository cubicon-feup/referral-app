defmodule AppWeb.SaleView do
  use AppWeb, :view
  alias AppWeb.SaleView

  def render("index.json", %{sales: sales}) do
    %{data: render_many(sales, SaleView, "sale.json")}
  end

  def render("show.json", %{sale: sale}) do
    %{data: render_one(sale, SaleView, "sale.json")}
  end

  def render("sale.json", %{sale: sale}) do
    %{id: sale.id,
      date: sale.date,
      value: sale.value}
  end
end
