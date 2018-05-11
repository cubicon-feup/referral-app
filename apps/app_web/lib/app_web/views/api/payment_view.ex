defmodule AppWeb.Api.PaymentView do
  use AppWeb, :view
  alias AppWeb.Api.PaymentView

  def render("index.json", %{payments: payments}) do
    %{data: render_many(payments, PaymentView, "payment.json")}
  end

  def render("show.json", %{payment: payment}) do
    %{data: render_one(payment, PaymentView, "payment.json")}
  end

  def render("payment.json", %{payment: payment}) do
    %{id: payment.id,
      type: payment.type,
      status: payment.status,
      value: payment.value}
  end
end
