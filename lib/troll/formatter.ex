defmodule Troll.Formatter do
  @moduledoc """
  Converts dice rolls to strings
  """

  @spec join_rolls(list(integer()), integer()) :: String.t()
  def join_rolls(rolls, mod) do
    Enum.join(rolls, "+") <> format_modifier(mod)
  end

  @spec format_expression(pos_integer(), pos_integer(), integer(), atom()) :: String.t()
  def format_expression(num_dice, num_sides, modifier, operation),
    do: format_dice(num_dice, num_sides) <> format_modifier(modifier, operation)

  defp format_dice(num_dice, num_sides), do: "#{num_dice}d#{num_sides}"

  @spec format_modifier(integer()) :: String.t()
  def format_modifier(0), do: ""
  def format_modifier(mod) when mod > 0, do: "+#{mod}"
  def format_modifier(mod) when mod < 0, do: " - #{abs(mod)}"
  defp format_modifier(0, _operation), do: ""
  defp format_modifier(mod, :*), do: "x#{mod}"
  defp format_modifier(mod, :+), do: format_modifier(mod)
  defp format_modifier(mod, :-), do: format_modifier(mod)
  defp format_modifier(mod, operation), do: "#{operation}#{mod}"
end

defimpl String.Chars, for: Troll.Check do
  def to_string(%{
        type: type,
        rolls: rolls,
        outcome: outcome,
        total: total,
        target: target,
        modifier: modifier
      }) do
    sign =
      case type do
        :over -> "≥"
        :under -> "≤"
      end

    outcome =
      case outcome do
        :success -> "Success"
        :failure -> "Failure"
      end

    "#{outcome}. Got: #{total} #{sign} #{target} (#{Troll.Formatter.join_rolls(rolls, modifier)})."
  end
end

defimpl String.Chars, for: Troll.Flux do
  def to_string(%{
        type: type,
        first: d1,
        second: d2,
        total: total,
        modifier: modifier,
        formula: formula
      }) do
    t =
      case type do
        :neutral -> "flux"
        type -> "#{type} flux"
      end

    mod = Troll.Formatter.format_modifier(modifier)

    expression = "#{d1}-#{d2}#{mod}"

    "Rolled #{t} (#{formula}), got: #{total} (#{expression})."
  end
end

defimpl Inspect, for: Troll.Formula do
  @moduledoc "Inspect protocol implementation for Troll.Formula"
  def inspect(formula, _opts) do
    "#Troll<#{formula.expression}>"
  end
end

defimpl String.Chars, for: Troll.Roll do
  def to_string(%{
        formula: formula,
        rolls: rolls,
        total: total,
        modifier: modifier
      }) do
    "Rolled #{formula}. Got: #{total} (#{Troll.Formatter.join_rolls(rolls, modifier)})."
  end
end
