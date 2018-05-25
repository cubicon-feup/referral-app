defmodule AppWeb.VoucherControllerTest do
  use AppWeb.ConnCase

  alias App.Vouchers

  @create_attrs %{code: "some code"}
  @update_attrs %{code: "some updated code"}
  @invalid_attrs %{code: nil}

  def fixture(:voucher) do
    {:ok, voucher} = Vouchers.create_voucher(@create_attrs)
    voucher
  end

  # describe "index" do
  #   test "lists all vouchers", %{conn: conn} do
  #     conn = get conn, contract_voucher_path(conn, :index, @contract)
  #     assert html_response(conn, 200) =~ "Listing Vouchers"
  #   end
  # end

  # describe "new voucher" do
  #   test "renders form", %{conn: conn} do
  #     conn = get conn, contract_voucher_path(conn, :new, @contract)
  #     assert html_response(conn, 200) =~ "New Voucher"
  #   end
  # end

  # describe "create voucher" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post conn, contract_voucher_path(conn, :create, @contract), voucher: @create_attrs

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == contract_voucher_path(conn, :show, @contract, id)

  #     conn = get conn, contract_voucher_path(conn, :show, @contract, id)
  #     assert html_response(conn, 200) =~ "Show Voucher"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, contract_voucher_path(conn, :create, @contract), voucher: @invalid_attrs
  #     assert html_response(conn, 200) =~ "New Voucher"
  #   end
  # end

  # describe "edit voucher" do
  #   setup [:create_voucher]

  #   test "renders form for editing chosen voucher", %{conn: conn, voucher: voucher} do
  #     conn = get conn, contract_voucher_path(conn, :edit, @contract, voucher)
  #     assert html_response(conn, 200) =~ "Edit Voucher"
  #   end
  # end

  # describe "update voucher" do
  #   setup [:create_voucher]

  #   test "redirects when data is valid", %{conn: conn, voucher: voucher} do
  #     conn = put conn, contract_voucher_path(conn, :update, @contract, voucher), voucher: @update_attrs
  #     assert redirected_to(conn) == contract_voucher_path(conn, :show, @contract, voucher)

  #     conn = get conn, contract_voucher_path(conn, :show, @contract, voucher)
  #     assert html_response(conn, 200) =~ "some updated code"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, voucher: voucher} do
  #     conn = put conn, contract_voucher_path(conn, :update, @contract, voucher), voucher: @invalid_attrs
  #     assert html_response(conn, 200) =~ "Edit Voucher"
  #   end
  # end

  # describe "delete voucher" do
  #   setup [:create_voucher]

  #   test "deletes chosen voucher", %{conn: conn, voucher: voucher} do
  #     conn = delete conn, contract_voucher_path(conn, :delete, @contract, voucher)
  #     assert redirected_to(conn) == contract_voucher_path(conn, :index, @contract)
  #     assert_error_sent 404, fn ->
  #       get conn, contract_voucher_path(conn, :show, @contract, voucher)
  #     end
  #   end
  # end

  # defp create_voucher(_) do
  #   voucher = fixture(:voucher)
  #   {:ok, voucher: voucher}
  # end
end
