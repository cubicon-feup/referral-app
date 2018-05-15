
defmodule App.Influencers do
  @moduledoc """
  The Influencers context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Influencers.Influencer

  @doc """
  Returns the list of influencers.

  ## Examples

      iex> list_influencers()
      [%Influencer{}, ...]

  """
  def list_influencers do
    Repo.all(Influencer)
  end

  @doc """
  Gets a single influencer.

  Raises `Ecto.NoResultsError` if the Influencer does not exist.

  ## Examples

      iex> get_influencer!(123)
      %Influencer{}

      iex> get_influencer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_influencer!(id), do: Repo.get!(Influencer, id)

  @doc """
  Creates a influencer.

  ## Examples

      iex> create_influencer(%{field: value})
      {:ok, %Influencer{}}

      iex> create_influencer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_influencer(attrs \\ %{}) do
    %Influencer{}
    |> Influencer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a influencer.

  ## Examples

      iex> update_influencer(influencer, %{field: new_value})
      {:ok, %Influencer{}}

      iex> update_influencer(influencer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_influencer(%Influencer{} = influencer, attrs) do
    influencer
    |> Influencer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Influencer.

  ## Examples

      iex> delete_influencer(influencer)
      {:ok, %Influencer{}}

      iex> delete_influencer(influencer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_influencer(%Influencer{} = influencer) do
    Repo.delete(influencer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking influencer changes.

  ## Examples

      iex> change_influencer(influencer)
      %Ecto.Changeset{source: %Influencer{}}

  """
  def change_influencer(%Influencer{} = influencer) do
    Influencer.changeset(influencer, %{})
  end

  def get_influencer_by_email!(email) do 
    Repo.get_by(Influencer, contact: email)
    |> Repo.preload(:contract)
  end

  def get_influencer_by_code(code) do
    query =
      from(
        i in Influencer,
        where: i.code == ^code,
        select: %{influencer_id: i.id}
      )

    case Repo.all(query) do
      [influencer | _] -> influencer |> Map.put("status", "ok")
      _ -> %{status: "influencer not found"}
    end
  end

  def get_influencer_by_user(user_id), do: Repo.get_by(Influencer, user_id: user_id) 

end
