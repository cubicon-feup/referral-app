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

influencer_create_attrs = %{address: "Rua Dr.Roberto Frias", nib: 258963147, name: "John Doe", user_id: user.id}
{:ok, influencer} = App.Influencers.create_influencer(influencer_create_attrs)


contract_create_attrs = %{current_amount: "120.5", is_requestable: true, minimum_amount_of_sales: "120.5", minimum_amout_of_views: 42, minimum_sales: "120.5", number_of_views: 42, percent_amount_on_sales: "120.5", send_notification_to_brand: true, send_notification_to_influencer: true, size_of_set_of_sales: 42, static_amount_on_sales: "120.5", static_amount_on_set_of_sales: "120.5", static_amount_on_views: "120.5", time_between_payments: 42, influencer_id: influencer.id, brand_id: brand.id}
{:ok, contract} = App.Contracts.create_contract(contract_create_attrs)


