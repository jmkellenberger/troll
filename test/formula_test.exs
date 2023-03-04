defmodule FormulaTest do
  use ExUnit.Case
  alias Troll.Formula
  doctest Formula

  describe "parse/1" do
    test "num dice" do
      assert Formula.parse("d6") ==
               {:ok, %Formula{input: "d6", num_dice: 1, num_sides: 6, modifier: 0, operation: :+}}

      assert Formula.parse("1d6") ==
               {:ok,
                %Formula{
                  input: "1d6",
                  num_dice: 1,
                  num_sides: 6,
                  modifier: 0,
                  operation: :+
                }}

      assert Formula.parse("10d6") ==
               {:ok,
                %Formula{
                  input: "10d6",
                  num_dice: 10,
                  num_sides: 6,
                  modifier: 0,
                  operation: :+
                }}

      assert Formula.parse("100d6") ==
               {:ok,
                %Formula{
                  input: "100d6",
                  num_dice: 100,
                  num_sides: 6,
                  modifier: 0,
                  operation: :+
                }}
    end

    test "num sides" do
      assert Formula.parse("d6") ==
               {:ok,
                %Formula{
                  input: "d6",
                  num_dice: 1,
                  num_sides: 6,
                  modifier: 0,
                  operation: :+
                }}

      assert Formula.parse("d60") ==
               {:ok,
                %Formula{
                  input: "d60",
                  num_dice: 1,
                  num_sides: 60,
                  modifier: 0,
                  operation: :+
                }}

      assert Formula.parse("d600") ==
               {:ok,
                %Formula{
                  input: "d600",
                  num_dice: 1,
                  num_sides: 600,
                  modifier: 0,
                  operation: :+
                }}
    end

    test "no modifier" do
      assert Formula.parse("d20") ==
               {:ok,
                %Formula{
                  input: "d20",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 0,
                  operation: :+
                }}

      assert Formula.parse("2d20") ==
               {:ok,
                %Formula{
                  input: "2d20",
                  num_dice: 2,
                  num_sides: 20,
                  modifier: 0,
                  operation: :+
                }}
    end

    test "addition modifier" do
      assert Formula.parse("d20") ==
               {:ok,
                %Formula{
                  input: "d20",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 0,
                  operation: :+
                }}

      assert Formula.parse("d20+1") ==
               {:ok,
                %Formula{
                  input: "d20+1",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 1,
                  operation: :+
                }}

      assert Formula.parse("d20+5") ==
               {:ok,
                %Formula{
                  input: "d20+5",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 5,
                  operation: :+
                }}
    end

    test "subtraction modifier" do
      assert Formula.parse("d20-1") ==
               {:ok,
                %Formula{
                  input: "d20-1",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 1,
                  operation: :-
                }}

      assert Formula.parse("d20-5") ==
               {:ok,
                %Formula{
                  input: "d20-5",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 5,
                  operation: :-
                }}
    end

    test "multiplication modifier" do
      assert Formula.parse("d20x1") ==
               {:ok,
                %Formula{
                  input: "d20x1",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 1,
                  operation: :x
                }}

      assert Formula.parse("d20x5") ==
               {:ok,
                %Formula{
                  input: "d20x5",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 5,
                  operation: :x
                }}
    end

    test "division modifier" do
      assert Formula.parse("d20/1") ==
               {:ok,
                %Formula{
                  input: "d20/1",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 1,
                  operation: :/
                }}

      assert Formula.parse("d20/5") ==
               {:ok,
                %Formula{
                  input: "d20/5",
                  num_dice: 1,
                  num_sides: 20,
                  modifier: 5,
                  operation: :/
                }}
    end
  end

  describe "errors" do
    test "no input" do
      assert Formula.parse("") == {:error, "could not decode formula"}
    end

    test "invalid input" do
      assert Formula.parse("asdf") == {:error, "could not decode formula. unexpected input: 'a'"}
    end

    test "syntax error" do
      assert Formula.parse("1dd") == {:error, "could not decode formula"}
      assert Formula.parse("1d10++") == {:error, "could not decode formula"}
      assert Formula.parse("d") == {:error, "could not decode formula"}
    end
  end
end
