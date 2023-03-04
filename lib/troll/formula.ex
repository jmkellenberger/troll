defmodule Troll.Formula do
  @moduledoc "Represents a parsed formula"

  defstruct ~w[input num_dice num_sides modifier operation]a

  @type t() :: %Troll.Formula{
          input: Troll.dice_expression(),
          num_dice: pos_integer(),
          num_sides: pos_integer(),
          modifier: integer(),
          operation: :+ | :- | :/ | :x
        }

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
  @spec parse(Troll.dice_formula()) :: {:ok, __MODULE__.t()} | {:error, String.t()}
  def parse(formula) do
    with {:ok, tokens, _} <- :dice_lexer.string(to_charlist(formula)),
         {:ok, {num_dice, :d, num_sides, operation, modifier}} <- :dice_parser.parse(tokens) do
      {:ok,
       %__MODULE__{
         input: formula,
         num_dice: num_dice,
         num_sides: num_sides,
         modifier: modifier,
         operation: operation
       }}
    else
      {:error, {_, :dice_lexer, {:illegal, chars}}, _} ->
        {:error, "could not decode formula. unexpected input: #{inspect(chars)}"}

      {:error, {_, :dice_parser, _}} ->
        {:error, "could not decode formula"}

      {:error, reason} ->
        {:error, reason}

      e when is_list(e) ->
        {:error, "could not decode formula"}
    end
  end
end

defimpl Inspect, for: Troll.Formula do
  @moduledoc "Inspect protocol implementation for Troll.Formula"
  def inspect(%{modifier: 0} = formula, _opts) do
    "#Troll<#{formula.num_dice}d#{formula.num_sides}>"
  end

  def inspect(formula, _opts) do
    "#Troll<#{formula.num_dice}d#{formula.num_sides}#{formula.operation}#{formula.modifier}>"
  end
end
