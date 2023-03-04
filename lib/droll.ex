defmodule Droll do
  @moduledoc """
  Simple implementation of standard dice notation

  See [The Wikipedia Page](https://en.wikipedia.org/wiki/Dice_notation) for
  more information.
  """

  alias Droll.{Formula, Roll}

  @type dice_formula :: String.t()

  @doc """
  Parse a standard dice notation formula

  Examples:

      iex> Droll.parse("d20")
      {:ok, %Droll.Formula{input: "d20", num_dice: 1, num_sides: 20, modifier: 0, operation: :+}}
      iex> Droll.parse("4d6")
      {:ok, %Droll.Formula{input: "4d6", num_dice: 4, num_sides: 6, modifier: 0, operation: :+}}
      iex> Droll.parse("1d6+1")
      {:ok, %Droll.Formula{input: "1d6+1", num_dice: 1, num_sides: 6, modifier: 1, operation: :+}}
      iex> Droll.parse("10d5-2")
      {:ok, %Droll.Formula{input: "10d5-2", num_dice: 10, num_sides: 5, modifier: 2, operation: :-}}
      iex> Droll.parse("1d10/1")
      {:ok, %Droll.Formula{input: "1d10/1", num_dice: 1, num_sides: 10, modifier: 1, operation: :/}}
      iex> Droll.parse("1d10x5")
      {:ok, %Droll.Formula{input: "1d10x5", num_dice: 1, num_sides: 10, modifier: 5, operation: :x}}
  """
  @spec parse(dice_formula()) :: {:ok, Formula.t()} | {:error, String.t()}
  defdelegate parse(formula), to: Formula

  @doc """
  Parses a dice formula and returns the result if successful.
  """
  @spec roll(dice_formula()) :: {:error, binary} | {:ok, Roll.t()}
  defdelegate roll(dice_formula), to: Roll
end
