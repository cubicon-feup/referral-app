defmodule AppWeb.BrandView do
  use AppWeb, :view
  alias AppWeb.BrandView

  def render("index.json", %{brands: brands}) do
    %{data: render_many(brands, BrandView, "brand.json")}
  end

  def render("show.json", %{brand: brand}) do
    %{data: render_one(brand, BrandView, "brand.json")}
  end

  def render("brand.json", %{brand: brand}) do
    %{id: brand.id,
      name: brand.name}
  end
end
