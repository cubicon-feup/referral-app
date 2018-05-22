# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.



user_create_attrs = %{date_of_birth: ~D[2010-04-17], deleted: false, email: "mail@mail.com", name: "John Doe", password: "password", picture_path: nil, privileges_level: "user"}
{:ok, user} = App.Users.create_user(user_create_attrs)


brand_create_attrs = %{api_key: "e1c4afd5632958dd66626a3257ac72d7", api_password: "b36782cbdc2d7991f2c804bcd63a9246", hostname: "duarte-store-29.myshopify.com", name: "Brandify", user_id: user.id}
{:ok, brand} = App.Brands.create_brand(brand_create_attrs)

influencer_create_attrs = %{address: "Rua Dr.Roberto Frias", nib: 258963147, name: "John Doe", user_id: user.id, contact: "example@mail.com"}
{:ok, influencer} = App.Influencers.create_influencer(influencer_create_attrs)


contract_create_attrs = %{influencer_id: influencer.id, brand_id: brand.id}
{:ok, contract} = App.Contracts.create_contract(contract_create_attrs)


voucher_create_attrs = %{contract_id: contract.id, code: "DISCOUNT20"}
{:ok, voucher} = App.Vouchers.create_voucher(voucher_create_attrs)

case NaiveDateTime.new(~D[2010-01-13], ~T[23:00:07.005]) do
{:ok, date} ->
sale1 = Ecto.build_assoc(voucher, :sales, date: date, value: 10)

sale2 = Ecto.build_assoc(voucher, :sales, date: date, value: 20)

sale3 = Ecto.build_assoc(voucher, :sales, date: date, value: 30)
App.Repo.insert!(sale1)
App.Repo.insert!(sale2)
App.Repo.insert!(sale3)

end
# sales_create_attrs = %{voucher: voucher, date: "2018-05-22 09:14:39.027866Z", value: 10}
# sales_create_attrs2 = %{voucher: voucher, date: "2018-05-22 09:14:39.027866Z", value: 30}
# sales_create_attrs3 = %{voucher: voucher, date: "2018-05-22 09:14:39.027866Z", value: 50}
# {:ok, sale} = App.Sales.create_sale(sales_create_attrs)
# {:ok, sale2} = App.Sales.create_sale(sales_create_attrs2)
# {:ok, sale3} = App.Sales.create_sale(sales_create_attrs3)