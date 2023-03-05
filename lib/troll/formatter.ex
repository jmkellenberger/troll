defmodule Troll.Formatter do
  @moduledoc """
  Converts dice rolls to strings
  """

  def join_rolls(rolls, mod) do
    Enum.join(rolls, " + ") <> format_modifier(mod)
  end

  def format_modifier(0), do: ""
  def format_modifier(mod) when mod > 0, do: "+ #{mod}"
  def format_modifier(mod) when mod < 0, do: " - #{abs(mod)}"
end
