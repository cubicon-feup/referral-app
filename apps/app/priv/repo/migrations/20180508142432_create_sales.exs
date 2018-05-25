defmodule App.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add(:date, :naive_datetime)
      add(:value, :decimal)
      add(:customer_locale, :string)
      add(:total_discounts, :decimal)
      add(:customer_id, :bigint)
      add(:date_sale, :naive_datetime)
      add(:voucher_id, references(:vouchers, on_delete: :nothing))

      timestamps()
    end
  end
end
