defmodule App.LinksTest do
  use App.DataCase
  
  alias App.Repo
  
  alias App.Contracts
  alias App.Users
  alias App.Brands
  alias App.Vouchers
  alias App.Links

  describe "links" do
    alias App.Links.Link

    @valid_attrs_user %{date_of_birth: ~D[2010-04-17], deleted: true, email: "some email", name: "some name", password: "some password", picture_path: "some picture_path", privileges_level: "user" }
    @valid_attrs_brand %{ api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name" }
    @valid_attrs_contract %{email: "some@mail.com", address: "some address", name: "some name", nib: 33}
    @valid_attrs_voucher %{code: "some code"}

    @valid_attrs %{shortcode: "some shortcode", url: "https://example.com"}
    @update_attrs %{shortcode: "some updated shortcode", url: "https://example2.com"}
    @invalid_attrs %{shortcode: nil, url: nil, user_id: nil, voucher_id: nil}

    
    def user_fixture() do
      {:ok, user} = Users.create_user(@valid_attrs_user)
      user
    end

    def brand_fixture() do
      {:ok, brand} = Brands.create_brand(@valid_attrs_brand)
      brand
    end

    def contract_fixture() do
      brand = brand_fixture()
      user = user_fixture()
      {:ok, contract} =
        %{user_id: user.id, brand_id: brand.id}
        |> Enum.into(@valid_attrs_contract)
        |> Contracts.create_contract()

      contract
    end

    def voucher_fixture() do
      contract = contract_fixture()
      {:ok, voucher} =
        %{contract_id: contract.id}
        |> Enum.into(@valid_attrs_voucher)
        |> Vouchers.create_voucher()

      voucher
    end

    def link_fixture(attrs \\ %{}) do
      voucher = voucher_fixture()
      user = user_fixture()
      {:ok, link} =
        attrs
        |> Enum.into(%{user_id: user.id, voucher_id: voucher.id})
        |> Enum.into(@valid_attrs)
        |> Links.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      voucher = voucher_fixture()
      user = user_fixture()
      assert {:ok, %Link{} = link} = %{user_id: user.id, voucher_id: voucher.id}
        |> Enum.into(@valid_attrs)
        |> Links.create_link()
      #assert link.shortcode == "some shortcode"
      assert link.url == "https://example.com"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, link} = Links.update_link(link, @update_attrs)
      assert %Link{} = link
      #assert link.shortcode == "some updated shortcode"
      assert link.url == "https://example2.com"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "link_from_url/1 returns vouchers" do
      link = link_fixture()
      assert Links.link_from_url("https://example.com") == link
    end

    test "link_from_shortcode/1 returns vouchers" do
      link = link_fixture()
      assert Links.link_from_shortcode(link.shortcode) == link
    end
  end
end
