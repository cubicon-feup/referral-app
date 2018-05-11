defmodule AppWeb.VoucherView do
  use AppWeb, :view
  alias App.Brands
  alias App.Price_rules.Price_rule
  alias App.Links

  def get_price_rule(brand, price_rule_id) do
    url = build_url(brand) <> "/admin/price_rules/#{price_rule_id}.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse =
          Poison.Parser.parse!(body)
          |> get_in(["price_rule"])
    end
  end

  def get_discount_code(brand, price_rule_id, discount_code_id) do
    url =
      build_url(brand) <>
        "/admin/price_rules/#{price_rule_id}/discount_codes/#{discount_code_id}.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse =
          Poison.Parser.parse!(body)
          |> get_in(["discount_code"])
    end
  end

  def get_price_rules(brand_id) do
    url = build_url(brand_id) <> "/admin/price_rules.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse =
          Poison.Parser.parse!(body)
          |> get_in(["price_rules"])
    end
  end

  def build_url(brand_id) do
    brand = Brands.get_brand!(brand_id)

    base_url = "https://" <> brand.api_key <> ":" <> brand.api_password <> "@" <> brand.hostname
  end
end
