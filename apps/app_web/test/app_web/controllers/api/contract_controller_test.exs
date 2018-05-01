defmodule AppWeb.Api.ContractControllerTest do
  use AppWeb.ConnCase

  alias App.Contracts
  alias App.Contracts.Contract
  alias App.Influencers
  alias App.Brands

  @valid_attrs_influencer %{address: "some address", code: "some code", name: "some name", nib: 42}
  @valid_attrs_brand %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}

  @create_attrs %{minimum_points: 42, payment_period: 42, points: 42}
  @update_attrs %{minimum_points: 43, payment_period: 43, points: 43}
  @invalid_attrs %{brand_id: nil, influencer_id: nil, minimum_points: nil, payment_period: nil, points: nil}

  def influencer_fixture() do
    {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)
  
    influencer
  end

  def brand_fixture() do
    {:ok, brand} = Brands.create_brand(@valid_attrs_brand)
  
    brand
  end

  def fixture(:contract) do
    influencer = influencer_fixture()
    brand = brand_fixture()

    {:ok, contract} =
      %{influencer_id: influencer.id, brand_id: brand.id}
      |> Enum.into(@create_attrs)
      |> Contracts.create_contract()

    contract
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, api_contract_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create contract" do
    test "renders contract when data is valid", %{conn: conn} do
      influencer = influencer_fixture();
      brand = brand_fixture();
      attrs = Enum.into(%{influencer_id: influencer.id, brand_id: brand.id}, @create_attrs)
      conn = post conn, api_contract_path(conn, :create), contract: attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "brand_id" => brand.id,
        "influencer_id" => influencer.id,
        "minimum_points" => 42,
        "payment_period" => 42,
        "points" => "42"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_contract_path(conn, :create), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contract" do
    setup [:create_contract]
    
    test "renders contract when data is valid", %{conn: conn, contract: %Contract{id: id} = contract} do
      influencer = influencer_fixture();
      brand = brand_fixture();
      attrs = Enum.into(%{influencer_id: influencer.id, brand_id: brand.id}, @update_attrs)

      conn = put conn, api_contract_path(conn, :update, contract), contract: attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "brand_id" => brand.id,
        "influencer_id" => influencer.id,
        "minimum_points" => 43,
        "payment_period" => 43,
        "points" => "43"}
    end

    test "renders errors when data is invalid", %{conn: conn, contract: contract} do
      conn = put conn, api_contract_path(conn, :update, contract), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      conn = delete conn, api_contract_path(conn, :delete, contract)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_contract_path(conn, :show, contract)
      end
    end
  end

  defp create_contract(_) do
    contract = fixture(:contract)
    {:ok, contract: contract}
  end
end
