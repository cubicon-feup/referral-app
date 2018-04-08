defmodule AppWeb.PaymentView do
  use AppWeb, :view
  alias AppWeb.PaymentView

  def render("index.json", %{payments: payments}) do
    %{data: render_many(payments, PaymentView, "payment.json")}
  end

  def render("show.json", %{payment: payment}) do
    %{data: render_one(payment, PaymentView, "payment.json")}
  end

  def render("payment.json", %{payment: payment}) do
    %{id: payment.id,
      requestDate: payment.requestDate,
      paid: payment.paid,
      value: payment.value}
  end
end
