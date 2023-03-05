defmodule Troll do
  @moduledoc """
  Simple implementation of standard dice notation

  See [The Wikipedia Page](https://en.wikipedia.org/wiki/Dice_notation) for
  more information.
  """

  alias Troll.Check
  alias Troll.Formula
  alias Troll.Flux
  alias Troll.Roll

  @doc """
  Parse a standard dice notation formula

  Examples:

      iex> Troll.parse("d20")
      {:ok, %Troll.Formula{input: "d20", num_dice: 1, num_sides: 20, modifier: 0, operation: :+}}
      iex> Troll.parse("4d6")
      {:ok, %Troll.Formula{input: "4d6", num_dice: 4, num_sides: 6, modifier: 0, operation: :+}}
      iex> Troll.parse("1d6+1")
      {:ok, %Troll.Formula{input: "1d6+1", num_dice: 1, num_sides: 6, modifier: 1, operation: :+}}
      iex> Troll.parse("10d5-2")
      {:ok, %Troll.Formula{input: "10d5-2", num_dice: 10, num_sides: 5, modifier: 2, operation: :-}}
      iex> Troll.parse("1d10/1")
      {:ok, %Troll.Formula{input: "1d10/1", num_dice: 1, num_sides: 10, modifier: 1, operation: :/}}
      iex> Troll.parse("1d10x5")
      {:ok, %Troll.Formula{input: "1d10x5", num_dice: 1, num_sides: 10, modifier: 5, operation: :x}}
  """
  @spec parse(String.t()) :: {:ok, Formula.t()} | {:error, String.t()}
  defdelegate parse(formula), to: Formula

  @doc """
  Parses a dice formula and returns the roll result if successful.
  """
  @spec roll(String.t()) :: {:error, binary} | {:ok, Roll.t()}
  defdelegate roll(dice_formula), to: Roll, as: :parse

  @spec roll(pos_integer, pos_integer, number) :: Troll.Roll.t()
  defdelegate roll(num_dice, num_sides, modifier \\ 0), to: Roll

  @doc """
  Rolls two six-sided dice and returns their difference.

  Equivalent to 2D6-7. Output range: -5 to 5.

  ### Types
  :neutral -> Subtracts the second die from the first.

  :good -> Subtracts the smallest die from the largest.

  :bad -> Subtracts the largest die from the smallest.
  """
  @spec flux(integer(), :neutral | :good | :bad) :: Flux.t()
  def flux(modifier \\ 0, type \\ :neutral), do: roll(2, 6, modifier) |> Flux.flux(type)

  @doc """
  Compares the result of a 2d6 roll against a target number.

  ### Check Types

  over: Roll >= Target

  under: Roll <= Target
  """
  @spec check(integer(), integer(), :over | :under) :: Check.t()
  def check(target \\ 8, modifier \\ 0, type \\ :over),
    do: roll(2, 6, modifier) |> Check.check(target, type)
end
