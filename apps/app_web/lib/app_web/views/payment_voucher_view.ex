defmodule AppWeb.Payment_voucherView do
  use AppWeb, :view
  alias AppWeb.Payment_voucherView

  def render("index.json", %{payment_voucher: payment_voucher}) do
    %{data: render_many(payment_voucher, Payment_voucherView, "payment_voucher.json")}
  end

  def render("show.json", %{payment_voucher: payment_voucher}) do
    %{data: render_one(payment_voucher, Payment_voucherView, "payment_voucher.json")}
  end

  def render("payment_voucher.json", %{payment_voucher: payment_voucher}) do
    %{id: payment_voucher.id,
      amount: payment_voucher.amount,
      expiration_date: payment_voucher.expiration_date,
      minimum_spent_to_use: payment_voucher.minimum_spent_to_use,
      maximum_spent_to_use: payment_voucher.maximum_spent_to_use,
      comulative_with_vouchers: payment_voucher.comulative_with_vouchers,
      comulative_with_sales: payment_voucher.comulative_with_sales}
  end
end
