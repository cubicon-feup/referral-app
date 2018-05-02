defmodule App.InfluencersTest do
  use App.DataCase

  alias App.Influencers

  describe "influencers" do
    alias App.Influencers.Influencer

    @valid_attrs %{address: "some address", code: "some code", name: "some name", nib: 42, contact: "some contact"}
    @update_attrs %{address: "some updated address", code: "some updated code", name: "some updated name", nib: 43, contact: "some updated contact"}
    @invalid_attrs %{address: nil, code: nil, name: nil, nib: nil, contact: nil}

    def influencer_fixture(attrs \\ %{}) do
      {:ok, influencer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Influencers.create_influencer()

      influencer
    end

    test "list_influencers/0 returns all influencers" do
      influencer = influencer_fixture()
      assert Influencers.list_influencers() == [influencer]
    end

    test "get_influencer!/1 returns the influencer with given id" do
      influencer = influencer_fixture()
      assert Influencers.get_influencer!(influencer.id) == influencer
    end

    test "create_influencer/1 with valid data creates a influencer" do
      assert {:ok, %Influencer{} = influencer} = Influencers.create_influencer(@valid_attrs)
      assert influencer.address == "some address"
      assert influencer.code == "some code"
      assert influencer.name == "some name"
      assert influencer.nib == 42
    end

    test "create_influencer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Influencers.create_influencer(@invalid_attrs)
    end

    test "update_influencer/2 with valid data updates the influencer" do
      influencer = influencer_fixture()
      assert {:ok, influencer} = Influencers.update_influencer(influencer, @update_attrs)
      assert %Influencer{} = influencer
      assert influencer.address == "some updated address"
      assert influencer.code == "some updated code"
      assert influencer.name == "some updated name"
      assert influencer.nib == 43
    end

    test "update_influencer/2 with invalid data returns error changeset" do
      influencer = influencer_fixture()
      assert {:error, %Ecto.Changeset{}} = Influencers.update_influencer(influencer, @invalid_attrs)
      assert influencer == Influencers.get_influencer!(influencer.id)
    end

    test "delete_influencer/1 deletes the influencer" do
      influencer = influencer_fixture()
      assert {:ok, %Influencer{}} = Influencers.delete_influencer(influencer)
      assert_raise Ecto.NoResultsError, fn -> Influencers.get_influencer!(influencer.id) end
    end

    test "change_influencer/1 returns a influencer changeset" do
      influencer = influencer_fixture()
      assert %Ecto.Changeset{} = Influencers.change_influencer(influencer)
    end
  end
end
