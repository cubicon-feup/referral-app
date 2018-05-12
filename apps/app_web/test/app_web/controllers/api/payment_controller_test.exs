defmodule AppWeb.Api.PaymentControllerTest do
  use AppWeb.ConnCase

  alias App.Payments
  alias App.Payments.Payment

  alias App.Influencers

  @create_attrs %{type: "voucher", value: "120.5"}
  @update_attrs %{type: "money", value: "456.7", status: "complete"}
  @invalid_attrs %{type: nil, value: nil}

  @valid_attrs_influencer %{address: "some address", name: "some name", nib: 42, contact: "some contact"}
  @valid_attrs_brand %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}


  def influencer_fixture() do
    {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)

    influencer
  end

  def brand_fixture() do
    {:ok, brand} = Brands.create_brand(@valid_attrs_brand)

    brand
  end

  def fixture(:payment) do
    influencer = influencer_fixture()
    brand = brand_fixture()

    {:ok, payment} =
      Enum.into(%{brand_id: brand.id, influencer_id: influencer.id}, @create_attrs)
      |> Payments.create_payment()

    Payments.get_payment!(payment.id)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payments", %{conn: conn} do
      conn = get conn, api_payment_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment" do
    test "renders payment when data is valid", %{conn: conn} do
      influencer = influencer_fixture()
      brand = brand_fixture()
      attrs = Enum.into(%{brand_id: brand.id, influencer_id: influencer.id}, @create_attrs)
      conn = post conn, api_payment_path(conn, :create), payment: attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_payment_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "type" => "voucher",
        "status" => "pending",
        "value" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_payment_path(conn, :create), payment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment" do
    setup [:create_payment]

    test "renders payment when data is valid", %{conn: conn, payment: %Payment{id: id} = payment} do
      conn = put conn, api_payment_path(conn, :update, payment), payment: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_payment_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "type" => "money",
        "status" => "complete",
        "value" => "456.7"}
    end

    test "renders errors when data is invalid", %{conn: conn, payment: payment} do
      conn = put conn, api_payment_path(conn, :update, payment), payment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete conn, api_payment_path(conn, :delete, payment)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_payment_path(conn, :show, payment)
      end
    end
  end

  defp create_payment(_) do
    payment = fixture(:payment)
    {:ok, payment: payment}
  end
end
