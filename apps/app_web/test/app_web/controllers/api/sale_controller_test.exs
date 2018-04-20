defmodule AppWeb.Api.SaleControllerTest do
  use AppWeb.ConnCase

  alias App.Sales
  alias App.Sales.Sale

  @create_attrs %{date: ~N[2010-04-17 14:00:00.000000], value: "120.5"}
  @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], value: "456.7"}
  @invalid_attrs %{date: nil, value: nil}

  def fixture(:sale) do
    {:ok, sale} = Sales.create_sale(@create_attrs)
    sale
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sales", %{conn: conn} do
      conn = get conn, api_sale_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create sale" do
    test "renders sale when data is valid", %{conn: conn} do
      conn = post conn, api_sale_path(conn, :create), sale: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_sale_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "date" => "2010-04-17T14:00:00.000000",
        "value" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_sale_path(conn, :create), sale: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update sale" do
    setup [:create_sale]

    test "renders sale when data is valid", %{conn: conn, sale: %Sale{id: id} = sale} do
      conn = put conn, api_sale_path(conn, :update, sale), sale: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_sale_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "date" => "2011-05-18T15:01:01.000000",
        "value" => "456.7"}
    end

    test "renders errors when data is invalid", %{conn: conn, sale: sale} do
      conn = put conn, api_sale_path(conn, :update, sale), sale: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete sale" do
    setup [:create_sale]

    test "deletes chosen sale", %{conn: conn, sale: sale} do
      conn = delete conn, api_sale_path(conn, :delete, sale)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_sale_path(conn, :show, sale)
      end
    end
  end

  defp create_sale(_) do
    sale = fixture(:sale)
    {:ok, sale: sale}
  end
end
