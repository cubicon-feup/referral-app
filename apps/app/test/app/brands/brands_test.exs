defmodule App.BrandsTest do
  use App.DataCase

  alias App.Brands
  
  describe "brands" do
    alias App.Brands.Brand

    @valid_attrs %{api_key: "some api_key", api_password: "some api_password", hostname: "some hostname", name: "some name"}
    @update_attrs %{api_key: "some updated api_key", api_password: "some updated api_password", hostname: "some updated hostname", name: "some updated name"}
    @invalid_attrs %{api_key: nil, api_password: nil, hostname: nil, name: nil}

    def brand_fixture(attrs \\ %{}) do
      {:ok, brand} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Brands.create_brand()

      brand
    end

    # test "list_brands/0 returns all brands" do
    #   brand = brand_fixture()
    #   assert Brands.list_brands() == [brand]
    # end

    test "get_brand!/1 returns the brand with given id" do
      brand = brand_fixture()
      assert Brands.get_brand!(brand.id) == brand
    end

    test "create_brand/1 with valid data creates a brand" do
      assert {:ok, %Brand{} = brand} = Brands.create_brand(@valid_attrs)
      assert brand.api_key == "some api_key"
      assert brand.api_password == "some api_password"
      assert brand.hostname == "some hostname"
      assert brand.name == "some name"
    end

    test "create_brand/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Brands.create_brand(@invalid_attrs)
    end

    test "update_brand/2 with valid data updates the brand" do
      brand = brand_fixture()
      assert {:ok, brand} = Brands.update_brand(brand, @update_attrs)
      assert %Brand{} = brand
      assert brand.api_key == "some updated api_key"
      assert brand.api_password == "some updated api_password"
      assert brand.hostname == "some updated hostname"
      assert brand.name == "some updated name"
    end

    test "update_brand/2 with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = Brands.update_brand(brand, @invalid_attrs)
      assert brand == Brands.get_brand!(brand.id)
    end

    test "delete_brand/1 deletes the brand" do
      brand = brand_fixture()
      assert {:ok, %Brand{}} = Brands.delete_brand(brand)
      assert_raise Ecto.NoResultsError, fn -> Brands.get_brand!(brand.id) end
    end

    test "change_brand/1 returns a brand changeset" do
      brand = brand_fixture()
      assert %Ecto.Changeset{} = Brands.change_brand(brand)
    end
  end
end
