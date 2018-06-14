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

user_create_attrs = %{
  date_of_birth: ~D[2010-04-17],
  deleted: false,
  email: "mail@mail.com",
  name: "Sara Sampaio",
  password: "password",
  picture_path: nil,
  privileges_level: "user"
}

{:ok, user} = App.Users.create_user(user_create_attrs)

user_create_attrs2 = %{
  date_of_birth: ~D[2010-04-17],
  deleted: false,
  email: "mail1@mail.com",
  name: "Daniela Ruah",
  password: "password",
  picture_path: nil,
  privileges_level: "user"
}

{:ok, user2} = App.Users.create_user(user_create_attrs2)

user_create_attrs3 = %{
  date_of_birth: ~D[2010-04-17],
  deleted: false,
  email: "mail2@mail.com",
  name: "Sofia Ribeiro",
  password: "password",
  picture_path: nil,
  privileges_level: "user"
}

{:ok, user3} = App.Users.create_user(user_create_attrs3)

user_create_attrs4 = %{
  date_of_birth: ~D[2010-04-17],
  deleted: false,
  email: "mail3@mail.com",
  name: "Cristina Ferreira",
  password: "password",
  picture_path: nil,
  privileges_level: "user"
}

{:ok, user4} = App.Users.create_user(user_create_attrs4)

user_create_attrs5 = %{
  date_of_birth: ~D[2010-04-17],
  deleted: false,
  email: "mail4@mail.com",
  name: "Rita Pereira",
  password: "password",
  picture_path: nil,
  privileges_level: "user"
}

{:ok, user5} = App.Users.create_user(user_create_attrs5)

user_create_attrs6 = %{
  date_of_birth: ~D[2010-04-17],
  deleted: false,
  email: "mail5@mail.com",
  name: "Isabel Figueira",
  password: "password",
  picture_path: nil,
  privileges_level: "user"
}

{:ok, user6} = App.Users.create_user(user_create_attrs6)

brand_create_attrs = %{
  api_key: "e1c4afd5632958dd66626a3257ac72d7",
  api_password: "b36782cbdc2d7991f2c804bcd63a9246",
  hostname: "duarte-store-29.myshopify.com",
  name: "Brandify",
  user_id: user.id
}

{:ok, brand} = App.Brands.create_brand(brand_create_attrs)

contract_create_attrs = %{
  brand_id: brand.id,
  address: "Rua Dr.Roberto Frias",
  nib: 258_963_147,
  name: "Sara Sampaio",
  user_id: user.id,
  email: "example@mail.com"
}

{:ok, contract} = App.Contracts.create_contract(contract_create_attrs)

contract_create_attrs2 = %{
  brand_id: brand.id,
  address: "Rua Dr.Roberto Frias",
  nib: 123_963_147,
  name: "Daniela Ruah",
  user_id: user.id,
  email: "example1@mail.com"
}

{:ok, contract2} = App.Contracts.create_contract(contract_create_attrs2)

contract_create_attrs3 = %{
  brand_id: brand.id,
  address: "Rua Dr.Roberto Frias",
  nib: 456_963_147,
  name: "Sofia Ribeiro",
  user_id: user.id,
  email: "example2@mail.com"
}

{:ok, contract3} = App.Contracts.create_contract(contract_create_attrs3)

contract_create_attrs4 = %{
  brand_id: brand.id,
  address: "Rua Dr.Roberto Frias",
  nib: 678_963_147,
  name: "Cristina Ferreira",
  user_id: user.id,
  email: "example3@mail.com"
}

{:ok, contract4} = App.Contracts.create_contract(contract_create_attrs4)

contract_create_attrs5 = %{
  brand_id: brand.id,
  address: "Rua Dr.Roberto Frias",
  nib: 789_963_147,
  name: "Rita Pereira",
  user_id: user.id,
  email: "example4@mail.com"
}

{:ok, contract5} = App.Contracts.create_contract(contract_create_attrs5)

contract_create_attrs6 = %{
  brand_id: brand.id,
  address: "Rua Dr.Roberto Frias",
  nib: 098_963_147,
  name: "Isabel Figueira",
  user_id: user.id,
  email: "example5@mail.com"
}

{:ok, contract6} = App.Contracts.create_contract(contract_create_attrs6)

voucher_create_attrs = %{contract_id: contract.id, code: "DISCOUNT20"}
{:ok, voucher} = App.Vouchers.create_voucher(voucher_create_attrs)
voucher_create_attrs2 = %{contract_id: contract2.id, code: "DISCOUNT21"}
{:ok, voucher1} = App.Vouchers.create_voucher(voucher_create_attrs2)
voucher_create_attrs3 = %{contract_id: contract3.id, code: "DISCOUNT22"}
{:ok, voucher2} = App.Vouchers.create_voucher(voucher_create_attrs3)
voucher_create_attrs4 = %{contract_id: contract4.id, code: "DISCOUNT23"}
{:ok, voucher3} = App.Vouchers.create_voucher(voucher_create_attrs4)
voucher_create_attrs5 = %{contract_id: contract5.id, code: "DISCOUNT24"}
{:ok, voucher4} = App.Vouchers.create_voucher(voucher_create_attrs5)
voucher_create_attrs6 = %{contract_id: contract6.id, code: "DISCOUNT25"}
{:ok, voucher5} = App.Vouchers.create_voucher(voucher_create_attrs6)

case NaiveDateTime.new(~D[2010-01-13], ~T[23:00:07.005]) do
  {:ok, date} ->
    sale1 =
      Ecto.build_assoc(
        voucher,
        :sales,
        date: date,
        value: 10.23,
        customer_id: 12345,
        customer_locale: "Portugal"
      )

    sale2 =
      Ecto.build_assoc(
        voucher1,
        :sales,
        date: date,
        value: 20.95,
        customer_id: 12346,
        customer_locale: "Spain"
      )

    sale3 =
      Ecto.build_assoc(
        voucher2,
        :sales,
        date: date,
        value: 30.23,
        customer_id: 12445,
        customer_locale: "USA"
      )

    sale4 =
      Ecto.build_assoc(
        voucher3,
        :sales,
        date: date,
        value: 10.15,
        customer_id: 12345,
        customer_locale: "Portugal"
      )

    sale5 =
      Ecto.build_assoc(
        voucher4,
        :sales,
        date: date,
        value: 20,
        customer_id: 12646,
        customer_locale: "Portugal"
      )

    sale6 =
      Ecto.build_assoc(
        voucher5,
        :sales,
        date: date,
        value: 30.45,
        customer_id: 12145,
        customer_locale: "USA"
      )

    sale7 =
      Ecto.build_assoc(
        voucher,
        :sales,
        date: date,
        value: 10.99,
        customer_id: 12345,
        customer_locale: "Portugal"
      )

    sale8 =
      Ecto.build_assoc(
        voucher1,
        :sales,
        date: date,
        value: 20.00,
        customer_id: 12346,
        customer_locale: "Spain"
      )

    sale9 =
      Ecto.build_assoc(
        voucher2,
        :sales,
        date: date,
        value: 30.05,
        customer_id: 12445,
        customer_locale: "USA"
      )

    sale10 =
      Ecto.build_assoc(
        voucher3,
        :sales,
        date: date,
        value: 100.23,
        customer_id: 12345,
        customer_locale: "Portugal"
      )

    sale11 =
      Ecto.build_assoc(
        voucher4,
        :sales,
        date: date,
        value: 20.15,
        customer_id: 12646,
        customer_locale: "Portugal"
      )

    sale12 =
      Ecto.build_assoc(
        voucher5,
        :sales,
        date: date,
        value: 30.28,
        customer_id: 12145,
        customer_locale: "USA"
      )

    sale13 =
      Ecto.build_assoc(
        voucher,
        :sales,
        date: date,
        value: 10.16,
        customer_id: 12345,
        customer_locale: "Portugal"
      )

    sale14 =
      Ecto.build_assoc(
        voucher1,
        :sales,
        date: date,
        value: 22.16,
        customer_id: 12346,
        customer_locale: "Spain"
      )

    sale15 =
      Ecto.build_assoc(
        voucher2,
        :sales,
        date: date,
        value: 36.25,
        customer_id: 12445,
        customer_locale: "USA"
      )

    sale16 =
      Ecto.build_assoc(
        voucher3,
        :sales,
        date: date,
        value: 17.26,
        customer_id: 12345,
        customer_locale: "Portugal"
      )

    sale17 =
      Ecto.build_assoc(
        voucher4,
        :sales,
        date: date,
        value: 21.16,
        customer_id: 12646,
        customer_locale: "Portugal"
      )

    sale18 =
      Ecto.build_assoc(
        voucher5,
        :sales,
        date: date,
        value: 30.67,
        customer_id: 12145,
        customer_locale: "USA"
      )

    App.Repo.insert!(sale1)
    App.Repo.insert!(sale2)
    App.Repo.insert!(sale3)
    App.Repo.insert!(sale4)
    App.Repo.insert!(sale5)
    App.Repo.insert!(sale6)
    App.Repo.insert!(sale7)
    App.Repo.insert!(sale8)
    App.Repo.insert!(sale9)
    App.Repo.insert!(sale10)
    App.Repo.insert!(sale11)
    App.Repo.insert!(sale12)
    App.Repo.insert!(sale13)
    App.Repo.insert!(sale14)
    App.Repo.insert!(sale15)
    App.Repo.insert!(sale16)
    App.Repo.insert!(sale17)
    App.Repo.insert!(sale18)
end

# sales_create_attrs = %{voucher: voucher, date: "2018-05-22 09:14:39.027866Z", value: 10}
# sales_create_attrs2 = %{voucher: voucher, date: "2018-05-22 09:14:39.027866Z", value: 30}
# sales_create_attrs3 = %{voucher: voucher, date: "2018-05-22 09:14:39.027866Z", value: 50}
# {:ok, sale} = App.Sales.create_sale(sales_create_attrs)
# {:ok, sale2} = App.Sales.create_sale(sales_create_attrs2)
# {:ok, sale3} = App.Sales.create_sale(sales_create_attrs3)
