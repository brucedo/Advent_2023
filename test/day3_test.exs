defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Given some point P, a String representing a Symbol, and a Map, fill_adjacency will insert the Symbol into the 9 points surrounding and including the point P." do
    point = %Point{x: 0, y: 0}

    origin_adj = Day3.fill_adjacency(%{}, point, "S")

    assert Map.has_key?(origin_adj, %Point{x: -1, y: -1})
    assert Map.has_key?(origin_adj, %Point{x: -0, y: -1})
    assert Map.has_key?(origin_adj, %Point{x: 1, y: -1})
    assert Map.has_key?(origin_adj, %Point{x: -1, y: 0})
    assert Map.has_key?(origin_adj, %Point{x: 0, y: 0})
    assert Map.has_key?(origin_adj, %Point{x: 1, y: 0})
    assert Map.has_key?(origin_adj, %Point{x: -1, y: 1})
    assert Map.has_key?(origin_adj, %Point{x: 0, y: 1})
    assert Map.has_key?(origin_adj, %Point{x: 1, y: 1})
  end

  test "Given some point P, a String representing a Symbol, and a Map, fill_adjacency will store the String in a list in those squares" do
    point = %Point{x: 0, y: 0}

    origin_adj = Day3.fill_adjacency(%{}, point, "S")

    assert Map.get(origin_adj, %Point{x: 0, y: 0}) |> is_list()
  end

  test "Given some point P and an adjacent point Q then fill_adjacency will store the symbols for each point as members of the list on those points that they overlap" do
    p = %Point{x: 0, y: 0}
    q = %Point{x: 2, y: 2}

    origin_adj = Day3.fill_adjacency(%{}, p, "P") |> Day3.fill_adjacency(q, "Q")

    adjacent = assert Map.get(origin_adj, %Point{x: 1, y: 1})

    assert Enum.any?(adjacent, fn s -> s == "P" end)
    assert Enum.any?(adjacent, fn s -> s == "Q" end)
    assert length(adjacent) == 2
  end

  test "Given some line of input then parse_line() should be able to return a list of {:Number, number, x-coord} and {:Symbol, symbol, x-coord} tuples" do
    input_line = "617*......"

    assert Day3.parse_line(input_line) == [{:Number, 617, 0}, {:Symbol, "*", 3}]
  end

  test "Given some parsed element tuple and a y-coordinate (line number), pointify() will replace the x-coordinate with a Point" do
    input = {:Number, 617, 0}

    assert Day3.pointify(input, 6) == {:Number, 617, %Point{x: 0, y: 6}}
  end



end
