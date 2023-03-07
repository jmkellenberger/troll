defmodule Troll do
  @moduledoc """
  Simple implementation of standard dice notation

  See [The Wikipedia Page](https://en.wikipedia.org/wiki/Dice_notation) for
  more information.
  """

  alias Troll.Check
  alias Troll.Flux
  alias Troll.Roll

  @doc """
  Parses a dice formula and returns the roll result if successful.
  """
  @spec parse_roll(String.t()) :: {:error, binary} | {:ok, Roll.t()}
  defdelegate parse_roll(dice_formula), to: Roll, as: :parse

  @doc """
  Rolls a number of dice with the given sides and applies the modifier to the result
  """
  @spec roll(pos_integer, pos_integer, number) :: Troll.Roll.t()
  defdelegate roll(num_dice, num_sides, modifier \\ 0), to: Roll

  @doc """
  Rolls two dice and returns their difference.

  ### Types
  :neutral -> Subtracts the second die from the first.

  :good -> Subtracts the smallest die from the largest.

  :bad -> Subtracts the largest die from the smallest.
  """
  @spec flux(integer(), pos_integer(), Flux.flux_type()) :: Flux.t()
  def flux(modifier \\ 0, sides \\ 6, type \\ :neutral) do
    roll(2, sides, modifier)
    |> Flux.flux(type)
  end

  @doc """
  Rolls two dice and subtracts the smaller roll from the larger.
  """
  @spec good_flux(integer(), pos_integer()) :: Flux.t()
  def good_flux(modifier \\ 0, sides \\ 6), do: flux(modifier, sides, :good)

  @doc """
  Rolls two dice and subtracts the larger from the smaller.
  """
  @spec bad_flux(integer(), pos_integer()) :: Flux.t()
  def bad_flux(modifier \\ 0, sides \\ 6), do: flux(modifier, sides, :bad)

  @doc """
  Rolls the given dice expression and checks whether it is equal to or greater than the target number.
  """
  @spec check_over(String.t(), integer()) :: {:error, binary} | {:ok, Troll.Check.t()}
  def check_over(dice, target) do
    case parse_roll(dice) do
      {:ok, roll} -> {:ok, Check.check(roll, target, :over)}
      err -> err
    end
  end

  @spec check_over(pos_integer(), pos_integer(), integer(), integer()) :: Troll.Check.t()
  def check_over(num_dice, num_sides, modifier, target) do
    roll(num_dice, num_sides, modifier)
    |> Check.check(target, :over)
  end

  @doc """
  Rolls the given dice expression and checks whether it is equal to or less than the target number.
  """
  @spec check_under(String.t(), integer()) :: {:error, binary} | {:ok, Troll.Check.t()}
  def check_under(dice, target) do
    case parse_roll(dice) do
      {:ok, roll} -> {:ok, Check.check(roll, target, :under)}
      err -> err
    end
  end

  @spec check_under(pos_integer(), pos_integer(), integer(), integer()) :: Troll.Check.t()
  def check_under(num_dice, num_sides, modifier, target) do
    roll(num_dice, num_sides, modifier)
    |> Check.check(target, :under)
  end
end
