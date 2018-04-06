defmodule AppWeb.VoucherView do
  use AppWeb, :view
  alias AppWeb.VoucherView

  def render("index.json", %{vouchers: vouchers}) do
    %{data: render_many(vouchers, VoucherView, "voucher.json")}
  end

  def render("show.json", %{voucher: voucher}) do
    %{data: render_one(voucher, VoucherView, "voucher.json")}
  end

  def render("voucher.json", %{voucher: voucher}) do
    %{id: voucher.id,
      amount: voucher.amount,
      free_shipping: voucher.free_shipping,
      expiration_date: voucher.expiration_date,
      minimum_spent_to_use: voucher.minimum_spent_to_use,
      maximum_spent_to_use: voucher.maximum_spent_to_use,
      comulative_with_vouchers: voucher.comulative_with_vouchers,
      comulative_with_sales: voucher.comulative_with_sales,
      uses_per_person: voucher.uses_per_person,
      uses: voucher.uses}
  end
end
