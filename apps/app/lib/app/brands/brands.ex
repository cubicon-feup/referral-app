defmodule App.Brands do
  @moduledoc """
  The Brands context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Brands.Brand
  alias App.Influencers.Influencer
  alias App.Contracts.Contract
  @doc """
  Returns the list of brands.

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

  """
  def list_brands do
    Repo.all(Brand)
  end

  @doc """
  Gets a single brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!(123)
      %Brand{}

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand!(id), do: Repo.get!(Brand, id)

  def get_brand(id), do: Repo.get(Brand, id)

  def get_brand_by_user(user_id), do: Repo.get_by(Brand, user_id: user_id) 

  @doc """
  Gets a all influencers of a brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand_influencers!(123)
      %Brand{}???

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand_influencers(id) do
    Repo.all(Influencer)
  end

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{field: value})
      {:ok, %Brand{}}

      iex> create_brand(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs \\ %{}) do
    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brand.

  ## Examples

      iex> update_brand(brand, %{field: new_value})
      {:ok, %Brand{}}

      iex> update_brand(brand, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brand(%Brand{} = brand, attrs) do
    brand
    |> Brand.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Brand.

  ## Examples

      iex> delete_brand(brand)
      {:ok, %Brand{}}

      iex> delete_brand(brand)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brand(%Brand{} = brand) do
    Repo.delete(brand)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brand changes.

  ## Examples

      iex> change_brand(brand)
      %Ecto.Changeset{source: %Brand{}}

  """
  def change_brand(%Brand{} = brand) do
    Brand.changeset(brand, %{})
  end

  def get_brand_by_hostname(hostname) do
    query =
      from(
        b in Brand,
        where: b.hostname == ^hostname,
        select: %{brand_id: b.id}
      )

    case Repo.all(query) do
      [brand | _] -> brand |> Map.put("status", "ok")
      _ -> %{status: "brand not found"}
    end
  end
end
