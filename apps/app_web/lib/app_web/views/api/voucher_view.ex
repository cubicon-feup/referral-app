defmodule AppWeb.Api.VoucherView do
  use AppWeb, :view
  alias AppWeb.Api.VoucherView

  def render("index.json", %{vouchers: vouchers}) do
    %{data: render_many(vouchers, VoucherView, "voucher.json")}
  end

  def render("show.json", %{voucher: voucher}) do
    %{data: render_one(voucher, VoucherView, "voucher.json")}
  end

  def render("voucher.json", %{voucher: voucher}) do
    %{id: voucher.id,
      code: voucher.code}
  end
end
