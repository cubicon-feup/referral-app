defmodule App.Rules do
  @moduledoc """
  The Rules context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Rules.Rule
  alias App.Contracts

  @doc """
  Returns the list of rules.

  ## Examples

      iex> list_rules()
      [%Rule{}, ...]

  """
  def list_rules do
    Repo.all(Rule)
  end

  @doc """
  Gets a single rule.

  Raises `Ecto.NoResultsError` if the Rule does not exist.

  ## Examples

      iex> get_rule!(123)
      %Rule{}

      iex> get_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rule!(id), do: Repo.get!(Rule, id)

  @doc """
  Creates a rule.

  ## Examples

      iex> create_rule(%{field: value})
      {:ok, %Rule{}}

      iex> create_rule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rule(attrs \\ %{}) do
    %Rule{}
    |> Rule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rule.

  ## Examples

      iex> update_rule(rule, %{field: new_value})
      {:ok, %Rule{}}

      iex> update_rule(rule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rule(%Rule{} = rule, attrs) do
    rule
    |> Rule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Rule.

  ## Examples

      iex> delete_rule(rule)
      {:ok, %Rule{}}

      iex> delete_rule(rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rule(%Rule{} = rule) do
    Repo.delete(rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rule changes.

  ## Examples

      iex> change_rule(rule)
      %Ecto.Changeset{source: %Rule{}}

  """
  def change_rule(%Rule{} = rule) do
    Rule.changeset(rule, %{})
  end

   @doc """
  TODO
  """
  def test do
    rule = get_rule!(1)
    add_view(rule)
  end

  def add_sale(%Rule{} = rule, sale_value) do
    #add_sale
    new_counter = rule.sales_counter + 1

    #calculate points 
    fixed = if (rule.set_of_sales != 0 and Integer.mod(new_counter, rule.set_of_sales) == 0) do
      Decimal.to_float(rule.points_on_sales)
    else
      0
    end
    percent = Float.floor(Decimal.to_float(rule.percent_on_sales) * sale_value, 2)
    points = fixed + percent
    
    #check if not zero
    if (points != 0) do
      contract = Contracts.get_contract!(rule.contract_id)
      Contracts.add_points(contract, points)
    end
    #update
    update_rule(rule, %{sales_counter: new_counter})
  end

  def add_view(%Rule{} = rule) do
    #add_sale
    new_counter = rule.views_counter + 1

    #calculate points 
    points = if (rule.set_of_views != 0 and Integer.mod(new_counter, rule.set_of_views) == 0) do
      Decimal.to_float(rule.points_on_views)
    else
      0
    end
    
    #check if not zero
    if (points != 0) do
      contract = Contracts.get_contract!(rule.contract_id)
      Contracts.add_points(contract, points)
    end
    #update
    update_rule(rule, %{views_counter: new_counter})
  end
end
