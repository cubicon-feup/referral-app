defmodule AppWeb.Api.BrandView do
  use AppWeb, :view
  alias AppWeb.Api.BrandView

  def render("index.json", %{brands: brands}) do
    %{data: render_many(brands, BrandView, "brand.json")}
  end

  def render("show.json", %{brand: brand}) do
    %{data: render_one(brand, BrandView, "brand.json")}
  end

  def render("brand.json", %{brand: brand}) do
    %{id: brand.id,
      name: brand.name,
      hostname: brand.hostname,
      api_key: brand.api_key,
      api_password: brand.api_password}
  end
end
