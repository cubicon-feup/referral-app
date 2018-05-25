defmodule AppWeb.Api.BrandControllerTest do
  use AppWeb.ConnCase

  alias App.Brands
  alias App.Brands.Brand

  @create_attrs %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}
  @update_attrs %{api_key: "some updated api_key", api_password: "some updated api_password", hostname: "some updated hostname", name: "some updated name"}
  @invalid_attrs %{api_key: nil, api_password: nil, hostname: nil, name: nil}

  def fixture(:brand) do
    {:ok, brand} = Brands.create_brand(@create_attrs)
    brand
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "delete brand" do
    setup [:create_brand]

    test "deletes chosen brand", %{conn: conn, brand: brand} do
      conn = delete conn, api_brand_path(conn, :delete, brand)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_brand_path(conn, :show, brand)
      end
    end
  end

  defp create_brand(_) do
    brand = fixture(:brand)
    {:ok, brand: brand}
  end
end
