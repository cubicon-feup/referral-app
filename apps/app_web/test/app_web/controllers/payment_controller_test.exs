defmodule AppWeb.PaymentControllerTest do
  use AppWeb.ConnCase

  alias App.Payments
  alias App.Influencers

  @create_attrs %{type: "voucher", value: "120.5"}
  @update_attrs %{type: "money", value: "456.7", status: "complete"}
  @invalid_attrs %{type: nil, value: nil}

  @valid_attrs_influencer %{address: "some address", name: "some name", nib: 42, contact: "some contact"}


  def influencer_fixture() do
    {:ok, influencer} = Influencers.create_influencer(@valid_attrs_influencer)

    influencer
  end

  def fixture(:payment) do
    influencer = influencer_fixture()

    {:ok, payment} =
      Enum.into(%{influencer_id: influencer.id}, @create_attrs)
      |> Payments.create_payment()

    Payments.get_payment!(payment.id)
  end

  describe "index" do
    test "lists all payments", %{conn: conn} do
      conn = get conn, payment_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Payments"
    end
  end

  describe "new payment" do
    test "renders form", %{conn: conn} do
      conn = get conn, payment_path(conn, :new)
      assert html_response(conn, 200) =~ "New Payment"
    end
  end

  describe "create payment" do
    test "redirects to show when data is valid", %{conn: conn} do
      influencer = influencer_fixture()
      attrs = Enum.into(%{influencer_id: influencer.id}, @create_attrs)
      conn = post conn, payment_path(conn, :create), payment: attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == payment_path(conn, :show, id)

      conn = get conn, payment_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Payment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_path(conn, :create), payment: @invalid_attrs
      assert html_response(conn, 200) =~ "New Payment"
    end
  end

  describe "edit payment" do
    setup [:create_payment]

    test "renders form for editing chosen payment", %{conn: conn, payment: payment} do
      conn = get conn, payment_path(conn, :edit, payment)
      assert html_response(conn, 200) =~ "Edit Payment"
    end
  end

  describe "update payment" do
    setup [:create_payment]

    test "redirects when data is valid", %{conn: conn, payment: payment} do
      conn = put conn, payment_path(conn, :update, payment), payment: @update_attrs
      assert redirected_to(conn) == payment_path(conn, :show, payment)

      conn = get conn, payment_path(conn, :show, payment)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, payment: payment} do
      conn = put conn, payment_path(conn, :update, payment), payment: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Payment"
    end
  end

  describe "delete payment" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete conn, payment_path(conn, :delete, payment)
      assert redirected_to(conn) == payment_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, payment_path(conn, :show, payment)
      end
    end
  end

  defp create_payment(_) do
    payment = fixture(:payment)
    {:ok, payment: payment}
  end
end
