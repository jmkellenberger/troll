defmodule Troll.Formula do
  @moduledoc "Represents a parsed formula"

  defstruct ~w[expression num_dice num_sides modifier operation]a

  @type t() :: %Troll.Formula{
          expression: Troll.dice_expression(),
          num_dice: pos_integer(),
          num_sides: pos_integer(),
          modifier: integer(),
          operation: operation()
        }

  @type operation() :: :+ | :- | :/ | :x

  @doc """
  Parse a standard dice notation formula

  Examples:

      iex> Troll.parse("d20")
      {:ok, %Troll.Formula{expression: "d20", num_dice: 1, num_sides: 20, modifier: 0, operation: :+}}
      iex> Troll.parse("4d6")
      {:ok, %Troll.Formula{expression: "4d6", num_dice: 4, num_sides: 6, modifier: 0, operation: :+}}
      iex> Troll.parse("1d6+1")
      {:ok, %Troll.Formula{expression: "1d6+1", num_dice: 1, num_sides: 6, modifier: 1, operation: :+}}
      iex> Troll.parse("10d5-2")
      {:ok, %Troll.Formula{expression: "10d5-2", num_dice: 10, num_sides: 5, modifier: 2, operation: :-}}
      iex> Troll.parse("1d10/1")
      {:ok, %Troll.Formula{expression: "1d10/1", num_dice: 1, num_sides: 10, modifier: 1, operation: :/}}
      iex> Troll.parse("1d10x5")
      {:ok, %Troll.Formula{expression: "1d10x5", num_dice: 1, num_sides: 10, modifier: 5, operation: :x}}
  """
  @spec parse(Troll.dice_formula()) :: {:ok, __MODULE__.t()} | {:error, String.t()}
  def parse(formula) do
    with {:ok, tokens, _} <- :dice_lexer.string(to_charlist(formula)),
         {:ok, {num_dice, :d, num_sides, operation, modifier}} <- :dice_parser.parse(tokens) do
      {:ok,
       %__MODULE__{
         expression: formula,
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

  @spec new(pos_integer, pos_integer, number) :: Troll.Formula.t()
  def new(num_dice, num_sides, modifier) when modifier < 0 do
    new(num_dice, num_sides, abs(modifier), :-)
  end

  def new(num_dice, num_sides, modifier) do
    new(num_dice, num_sides, abs(modifier), :+)
  end

  @spec new(pos_integer(), pos_integer(), integer(), operation()) :: Troll.Formula.t()
  def new(num_dice, num_sides, modifier, operation) when num_dice > 0 and num_sides > 1 do
    %__MODULE__{
      expression: format_expression(num_dice, num_sides, modifier, operation),
      num_dice: num_dice,
      num_sides: num_sides,
      modifier: modifier,
      operation: operation
    }
  end

  defp format_expression(num_dice, num_sides, modifier, operation),
    do: format_dice(num_dice, num_sides) <> format_modifier(modifier, operation)

  defp format_dice(num_dice, num_sides), do: "#{num_dice}d#{num_sides}"

  defp format_modifier(0, _operation), do: ""
  defp format_modifier(mod, :*), do: "x#{mod}"
  defp format_modifier(mod, :+) when mod < 0, do: to_string(mod)
  defp format_modifier(mod, :-) when mod < 0, do: "+#{abs(mod)}"
  defp format_modifier(mod, operation), do: "#{operation}#{mod}"
end

defimpl Inspect, for: Troll.Formula do
  @moduledoc "Inspect protocol implementation for Troll.Formula"
  def inspect(formula, _opts) do
    "#Troll<#{formula.expression}>"
  end
end
