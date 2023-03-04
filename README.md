# Troll

Standard Dice Notation in Elixir. See [the Wikipedia page](https://en.wikipedia.org/wiki/Dice_notation)
for a full description of the notation.

This project is a fork of [connorrigby/droll](https://github.com/connorrigby/droll).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `troll` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:troll, "~> 1.0.0"}
  ]
end
```

## Usage

Example of rolling a 1 single 20 sided dice:

```elixir
iex(1)> Troll.roll("d20")
{:ok, %Troll.Roll{avg: 3.0, max: 0, min: 3, rolls: [3], total: 3}}
iex(2)> Troll.roll("d20")
{:ok, %Troll.Roll{avg: 20.0, max: 0, min: 20, rolls: [20], total: 20}}
iex(3)> Troll.roll("d20")
{:ok, %Troll.Roll{avg: 19.0, max: 0, min: 19, rolls: [19], total: 19}}
iex(4)> Troll.roll("d20")
{:ok, %Troll.Roll{avg: 17.0, max: 0, min: 17, rolls: [17], total: 17}}
```

Example of rolling 4 20 sided dice:

```elixir
iex(1)> Troll.roll("2d20")
{:ok, %Troll.Roll{avg: 10.0, max: 0, min: 17, rolls: [3, 17], total: 20}}
iex(2)> Troll.roll("2d20")
{:ok, %Troll.Roll{avg: 15.0, max: 0, min: 16, rolls: [14, 16], total: 30}}
iex(3)> Troll.roll("2d20")
{:ok, %Troll.Roll{avg: 17.5, max: 0, min: 18, rolls: [18, 17], total: 35}}
iex(4)> Troll.roll("2d20")
{:ok, %Troll.Roll{avg: 18.5, max: 0, min: 19, rolls: [19, 18], total: 37}}
```

Example of modifiers:

```elixir
iex(1)> Troll.roll("2d20+10")
{:ok, %Troll.Roll{avg: 17.0, max: 0, min: 15, rolls: [9, 15], total: 34}}
iex(2)> Troll.roll("2d20/1") 
{:ok, %Troll.Roll{avg: 12.5, max: 0, min: 18, rolls: [7, 18], total: 25.0}}
iex(3)> Troll.roll("2d20x8")
{:ok, %Troll.Roll{avg: 5.5, max: 0, min: 10, rolls: [10, 1], total: 11}}
iex(4)> Troll.roll("2d20-3")
{:ok, %Troll.Roll{avg: 9.5, max: 0, min: 12, rolls: [12, 10], total: 19}}
```

