defmodule Day3Test do
  require Logger
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

    assert Enum.any?(adjacent, fn s -> elem(s, 1) == "P" end)
    assert Enum.any?(adjacent, fn s -> elem(s, 1) == "Q" end)
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

  test "Given an appropriat sequence of mixed numbers & symbols & .s, parse_lines will convert them into a list of lists of parsed elements" do
    lines = ["467..114..", "...*......", "..35..633.", "......#...", "617*......", ".....+.58.",
      "..592.....", "......755.", "...$.*....", ".664.598.."]

    parsed_lines = Day3.parse_lines(lines, 0)

    assert parsed_lines == [
      [{:Number, 467, %Point{x: 0, y: 0}}, {:Number, 114, %Point{x: 5, y: 0}}],
      [{:Symbol, "*", %Point{x: 3, y: 1}}],
      [{:Number, 35, %Point{x: 2, y: 2}}, {:Number, 633, %Point{x: 6, y: 2}}],
      [{:Symbol, "#", %Point{x: 6, y: 3}}],
      [{:Number, 617, %Point{x: 0, y: 4}}, {:Symbol, "*", %Point{x: 3, y: 4}}],
      [{:Symbol, "+", %Point{x: 5, y: 5}}, {:Number, 58, %Point{x: 7, y: 5}}],
      [{:Number, 592, %Point{x: 2, y: 6}}],
      [{:Number, 755, %Point{x: 6, y: 7}}],
      [{:Symbol, "$", %Point{x: 3, y: 8}}, {:Symbol, "*", %Point{x: 5, y: 8}}],
      [{:Number, 664, %Point{x: 1, y: 9}}, {:Number, 598, %Point{x: 5, y: 9}}]
    ]
  end

  test "Given a mixed flattened list of parsed elements, split_parts will return {:Number_types_only, :Symbol_types_only}" do
    test_set = [
      {:Number, 467, %Point{x: 0, y: 0}}, {:Number, 114, %Point{x: 5, y: 0}},
      {:Symbol, "*", %Point{x: 3, y: 1}}, {:Number, 35, %Point{x: 2, y: 2}},
      {:Number, 633, %Point{x: 6, y: 2}}, {:Symbol, "#", %Point{x: 6, y: 3}},
      {:Number, 617, %Point{x: 0, y: 4}}, {:Symbol, "*", %Point{x: 3, y: 4}},
      {:Symbol, "+", %Point{x: 5, y: 5}}, {:Number, 58, %Point{x: 7, y: 5}},
      {:Number, 592, %Point{x: 2, y: 6}}, {:Number, 755, %Point{x: 6, y: 7}},
      {:Symbol, "$", %Point{x: 3, y: 8}}, {:Symbol, "*", %Point{x: 5, y: 8}},
      {:Number, 664, %Point{x: 1, y: 9}}, {:Number, 598, %Point{x: 5, y: 9}}
    ]

    assert Day3.split_parts(test_set) == {
      [
        {:Number, 467, %Point{x: 0, y: 0}}, {:Number, 114, %Point{x: 5, y: 0}},
        {:Number, 35, %Point{x: 2, y: 2}}, {:Number, 633, %Point{x: 6, y: 2}},
        {:Number, 617, %Point{x: 0, y: 4}}, {:Number, 58, %Point{x: 7, y: 5}},
        {:Number, 592, %Point{x: 2, y: 6}}, {:Number, 755, %Point{x: 6, y: 7}},
        {:Number, 664, %Point{x: 1, y: 9}}, {:Number, 598, %Point{x: 5, y: 9}}
      ],
      [
        {:Symbol, "*", %Point{x: 3, y: 1}}, {:Symbol, "#", %Point{x: 6, y: 3}},
        {:Symbol, "*", %Point{x: 3, y: 4}}, {:Symbol, "+", %Point{x: 5, y: 5}},
        {:Symbol, "$", %Point{x: 3, y: 8}}, {:Symbol, "*", %Point{x: 5, y: 8}}
      ]
    }
  end

  test "Just go ahead and run the sample from the challenge already" do
    lines = ["467..114..", "...*......", "..35..633.", "......#...", "617*......", ".....+.58.",
      "..592.....", "......755.", "...$.*....", ".664.598.."]

    parsed_elements = Day3.parse_lines(lines, 0)
    {numbers, symbols} = Day3.split_parts(parsed_elements)

    adjacency_map = Day3.capture_symbols(symbols)

    adjacent_sum = Enum.filter(numbers, &Day3.is_adjacent?(&1, adjacency_map)) |> Enum.map(&elem(&1, 1)) |> Enum.sum()

    assert adjacent_sum == 4361

  end

  test "Test part 2 now too." do
    lines = ["467..114..", "...*......", "..35..633.", "......#...", "617*......", ".....+.58.",
      "..592.....", "......755.", "...$.*....", ".664.598.."]

      parsed_elements = Day3.parse_lines(lines, 0)
      {numbers, symbols} = Day3.split_parts(parsed_elements)

      gears_only = symbols |> Enum.filter(fn element -> elem(element, 1) == "*" end)
      gear_map = Day3.capture_symbols(gears_only)

      temp = Enum.filter(numbers, &Day3.is_adjacent?(&1, gear_map))
      Logger.debug("#{inspect temp}")
      temp = Enum.map(temp, fn (number) -> {Day3.gear_point(number, gear_map), elem(number, 1)} end)
      Logger.debug("#{inspect temp}")
      temp = List.foldl(temp, %{}, fn e, acc ->
        elem(Map.get_and_update(acc, elem(e, 0), fn v -> {v, if v == nil do [elem(e, 1)] else [elem(e, 1)] ++ v end} end), 1) end)

      Logger.debug("#{inspect temp}")

      temp = Enum.filter(Map.values(temp), fn ratios -> length(ratios) == 2 end)

      Logger.debug("#{inspect temp}")

      temp = Enum.map(temp, fn pair -> Enum.product(pair) end)
      Logger.debug("#{inspect temp}")

      assert Enum.sum(temp) == 467835

  end

end
