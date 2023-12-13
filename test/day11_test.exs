defmodule Day11Test do
  require Logger
  use ExUnit.Case
  doctest(Day11)

  test "Given a list of only '.' characters, has_galaxies? will return false" do
    empty_space = [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]

    assert Day11.has_galaxies?(empty_space) == false

  end

  test "Given a list of mixed '.' and '#', has_galaxies? will return true" do
    galactic_space = [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."]

    assert Day11.has_galaxies?(galactic_space)
  end

  test "Given a list comprised of only empty space lines, expand_line will insert one additional empty space line for each in the original list" do
    galactic_field = [
      [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
      [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]
    ]

    expanded_field = Day11.expand_line(galactic_field)

    assert length(expanded_field) == 4

    assert Enum.all?(galactic_field, fn line -> line == [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."] end)
  end

  test "Given a list comprised of only lines with galaxies, expand_line will insert no additional empty space lines" do
    galactic_field = [
      [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."],
      [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."]
    ]

    expanded_field = Day11.expand_line(galactic_field)

    assert length(expanded_field) == 2

    assert Enum.all?(galactic_field, fn line -> line == [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."] end)
  end

  test "Given a completely empty 2x2 universe, expand_universe will generate a 4x4 universe" do
    universe = [[".", "."], [".", "."]]

    expanded_universe = Day11.expand_universe(universe)

    assert expanded_universe == [[".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."]]
  end

  test "Given a completely empty asymmetrical 2x4 universe, expand_universe will generate a 4x8 universe" do
    universe = [[".", "."], [".", "."], [".", "."], [".", "."]]

    expanded_universe = Day11.expand_universe(universe)
    assert expanded_universe == [ [".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."],
                                  [".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."], [".", ".", ".", "."]]
  end

  test "Given a completely empty asymmetrical 4x2 universe, expand_universe will generate an 8x4 universe" do
    universe = [[".", ".", ".", "."], [".", ".", ".", "."]]

    expanded_universe = Day11.expand_universe(universe)
    assert expanded_universe == [ [".", ".", ".", ".", ".", ".", ".", "."], [".", ".", ".", ".", ".", ".", ".", "."],
                                  [".", ".", ".", ".", ".", ".", ".", "."], [".", ".", ".", ".", ".", ".", ".", "."]]
  end

  test "Given a 2x2 universe where each line and column contains at least one galaxy expand_universe will generate a 2x2 universe identical to the original" do
    universe = [["#", "."], [".", "#"]]

    expanded_universe = Day11.expand_universe(universe)

    assert expanded_universe == [["#", "."], [".", "#"]]
  end

  test "Given a 2x2 universe where the leading column has no galaxies then expand_universe will generate a 3x2 universe with galaxies in the trailing column" do
    universe = [[".", "#"], [".", "#"]]

    expanded_universe = Day11.expand_universe(universe)

    assert expanded_universe == [[".", ".", "#"], [".", ".", "#"]]
  end

  test "Given a 2x2 universe where the trailing column has no galaxies then expand_universe will generate a 3x2 universe with the galaxies in the leading column" do
    universe = [["#", "."], ["#", "."]]

    expanded_universe = Day11.expand_universe(universe)

    assert expanded_universe == [["#", ".", "."], ["#", ".", "."]]
  end

  test "Given a 2x2 universe where the top row has all galaxies then expand_universe will generate a 2x3 universe with galaxies in the top row" do
    universe = [["#", "#"], [".", "."]]

    Day11.expand_universe(universe) == [["#", "#"], [".", "."], [".", "."]]
  end

  test "Testing the sample provided" do
    lines = [
      "...#......",
      ".......#..",
      "#.........",
      "..........",
      "......#...",
      ".#........",
      ".........#",
      "..........",
      ".......#..",
      "#...#....."
    ]
    universe = Enum.map(lines, fn line -> String.graphemes(line) end)

    expanded_universe = Day11.expand_universe(universe)

    assert Enum.map(expanded_universe, fn line -> List.to_string(line) end) ==
      [
        "....#........",
        ".........#...",
        "#............",
        ".............",
        ".............",
        "........#....",
        ".#...........",
        "............#",
        ".............",
        ".............",
        ".........#...",
        "#....#......."
      ]

  end

  test "Given an input grid with 2 galaxies, find_pairs will return one tuple of the Points of each galaxy" do
    galaxy = [["#", "."], [".", "#"]]

    assert Day11.find_pairs(galaxy) == [{%Point{x: 0, y: 0}, %Point{x: 1, y: 1}}]
  end

  test "Given an input grid with 3 galaxies, find_pairs will return 3 tuples of all combinations of pairs in the galaxy" do
    galaxy = [["#", ".", "."], [".", "#", "#"]]

    pairs = Day11.find_pairs(galaxy)

    assert length(pairs) == 3
  end

  test "Test pairs against the expanded input grid" do
    lines = [
      "....#........",
      ".........#...",
      "#............",
      ".............",
      ".............",
      "........#....",
      ".#...........",
      "............#",
      ".............",
      ".............",
      ".........#...",
      "#....#......."
    ]
    universe = Enum.map(lines, fn line -> String.graphemes(line) end)

    pairs = Day11.find_pairs(universe)
    assert length(pairs) == 36

    for pair <- pairs, do: Logger.debug("#{inspect pair}")

    calculated_distances = Enum.map(pairs, &Day11.calculate_taxi_distance/1)
    Logger.debug("#{inspect(calculated_distances)}")
    total_dist = Enum.sum(calculated_distances)
    assert 374 == total_dist
  end

  test "Given a list of lists of space elements, find_empty_rows will return the 0-based indices of those rows that are empty" do
    lines = [
      "...#......",
      ".......#..",
      "#.........",
      "..........",
      "......#...",
      ".#........",
      ".........#",
      "..........",
      ".......#..",
      "#...#....."
    ]
    universe = Enum.map(lines, fn line -> String.graphemes(line) end)

    empty_rows = Day11.find_empty_rows(universe)
    empty_columns = Enum.zip_with(universe, &Function.identity/1) |> Day11.find_empty_rows()

    assert empty_rows == [3, 7]
    assert empty_columns == [2, 5, 8]
  end

  test "Given a pair of points {4, 4} and {6, 6} and empty row/column lists that do not coincide with the path between the two points, find_big_distance will return 4" do
    pair = {%Point{x: 4, y: 4}, %Point{x: 6, y: 6}}
    empty_rows = [1, 2, 8]
    empty_columns = [ 2, 7, 12]

    assert Day11.big_distance(pair, empty_rows, empty_columns, 1000000) == 4
  end

  test "Given a pair of points {4, 4} and {6, 6} and empty row/column lists where one row coincides with the path between the two points, find_big_distance will return 1,000,003" do
    pair = {%Point{x: 4, y: 4}, %Point{x: 6, y: 6}}
    empty_rows = [1, 5, 8]
    empty_columns = [ 2, 7, 12]

    assert Day11.big_distance(pair, empty_rows, empty_columns, 1000000) == 1000003
  end

  test "Given a pair of points {4, 4} and {6, 6} and empty row_column lists where one column coincides with the path between the two points, find_big_distances will return 1,000,003" do
    pair = {%Point{x: 4, y: 4}, %Point{x: 6, y: 6}}
    empty_rows = [1, 2, 8]
    empty_columns = [ 2, 5, 12]

    assert Day11.big_distance(pair, empty_rows, empty_columns, 1000000) == 1000003
  end

  test "Given a pair of points {4, 4} and {6, 6} and empty row_column lists where one row and column coincide with the path between the points, find_big_distances will return 2,000,002" do
    pair = {%Point{x: 4, y: 4}, %Point{x: 6, y: 6}}
    empty_rows = [1, 5, 8]
    empty_columns = [ 2, 5, 12]

    assert Day11.big_distance(pair, empty_rows, empty_columns, 1000000) == 2000002
  end

  test "Given a pair of points {1, 1} and {10, 10} where empty_row and empty_space coincide with all points between the paths, find_big_distances will return 18000002" do
    pair = {%Point{x: 1, y: 1}, %Point{x: 10, y: 10}}
    empty_rows =  [2, 3, 4, 5, 6, 7, 8, 9]
    empty_columns = [2, 3, 4, 5, 6, 7, 8, 9]

    assert Day11.big_distance(pair, empty_rows, empty_columns, 1000000) == 16000002
  end

  test "Try the example with multiplicand of 10" do
    lines = [
      "...#......",
      ".......#..",
      "#.........",
      "..........",
      "......#...",
      ".#........",
      ".........#",
      "..........",
      ".......#..",
      "#...#....."
    ]
    universe = Enum.map(lines, fn line -> String.graphemes(line) end)

    empty_rows = Day11.find_empty_rows(universe)
    empty_columns = Enum.zip_with(universe, &Function.identity/1) |> Day11.find_empty_rows()
    pairs = Day11.find_pairs(universe)

    calculated_distances = Enum.map(pairs, fn pair -> Day11.big_distance(pair, empty_rows, empty_columns, 10) end)
    Logger.debug("#{inspect(calculated_distances)}")
    total_dist = Enum.sum(calculated_distances)
    assert 1030 == total_dist

  end

  test "Try the example with an expansion multiplier of 100" do
    lines = [
      "...#......",
      ".......#..",
      "#.........",
      "..........",
      "......#...",
      ".#........",
      ".........#",
      "..........",
      ".......#..",
      "#...#....."
    ]
    universe = Enum.map(lines, fn line -> String.graphemes(line) end)

    empty_rows = Day11.find_empty_rows(universe)
    empty_columns = Enum.zip_with(universe, &Function.identity/1) |> Day11.find_empty_rows()
    pairs = Day11.find_pairs(universe)

    calculated_distances = Enum.map(pairs, fn pair -> Day11.big_distance(pair, empty_rows, empty_columns, 100) end)
    Logger.debug("#{inspect(calculated_distances)}")
    total_dist = Enum.sum(calculated_distances)
    assert 8410 == total_dist
  end

end
