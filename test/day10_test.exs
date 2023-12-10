defmodule Day10Test do
  require Logger
  alias ExUnit.Assertions
  use ExUnit.Case
  doctest(Day10)

  test "Given a | symbol and its coordinate (x, y), tile_to_points will return two points at (x, y+1/y-1)" do
    pipe_endpoints = Day10.tile_to_points(%Point{x: 5, y: 5}, "|")

    assert pipe_endpoints == {%Point{x: 5, y: 4}, %Point{x: 5, y: 6}}
  end

  test "Given a - symbol and its coordinate (x, y), tile_to_points will return two points at (x-1/x+1, y)" do
    pipe_endpoints = Day10.tile_to_points(%Point{x: 5, y: 5}, "-")

    assert pipe_endpoints == {%Point{x: 4, y: 5}, %Point{x: 6, y: 5}}
  end

  test "Given a L symbol and its coordinate (x, y), til_to_points will return two points at (x, y-1) and (x+1, y)" do
    pipe_endpoints = Day10.tile_to_points(%Point{x: 5, y: 5}, "L")

    assert pipe_endpoints == {%Point{x: 5, y: 4}, %Point{x: 6, y: 5}}
  end

  test "Given a J symbol and its coordinate (x, y), tile_to_points will return two points at (x, y-1) and (x-1, y)" do
    pipe_endpoints = Day10.tile_to_points(%Point{x: 5, y: 5}, "J")

    assert pipe_endpoints == {%Point{x: 5, y: 4}, %Point{x: 4, y: 5}}
  end

  test "Given a 7 symbol and its coordinate (x, y), tile_to_points will return two points at (x-1, y) and (x, y+1)" do
    pipe_endpoints = Day10.tile_to_points(%Point{x: 5, y: 5}, "7")

    assert pipe_endpoints == {%Point{x: 4, y: 5}, %Point{x: 5, y: 6}}
  end

  test "Given a F symbol and its coordinates (x, y), tile_to_points will return two points (x+1, y) and (x, y+1)" do
    pipe_endpoints = Day10.tile_to_points(%Point{x: 5, y: 5}, "F")

    assert pipe_endpoints == {%Point{x: 6, y: 5}, %Point{x: 5, y: 6}}
  end

  test "Given some input line with one | and a row index, load_line will return a map with one element whose key is that symbol's point and whose values are points above and below the symbol" do
    line = "....|...."
    row = 5

    map = Day10.load_line(line, row)

    assert Map.has_key?(map, %Point{x: 4, y: 5})
    assert map_size(map) == 1
    assert Map.get(map, %Point{x: 4, y: 5}) == {%Point{x: 4, y: 4}, %Point{x: 4, y: 6}}
  end

  test "Given som einput line with one each of the symbols, load_line will return a map with one element per symbol" do
    line = "|-LJ7F"

    map = Day10.load_line(line, 6)

    assert Map.get(map, %Point{x: 0, y: 6}) == {%Point{x: 0, y: 5}, %Point{x: 0, y: 7}}
    assert Map.get(map, %Point{x: 1, y: 6}) == {%Point{x: 0, y: 6}, %Point{x: 2, y: 6}}
    assert Map.get(map, %Point{x: 2, y: 6}) == {%Point{x: 2, y: 5}, %Point{x: 3, y: 6}}
    assert Map.get(map, %Point{x: 3, y: 6}) == {%Point{x: 3, y: 5}, %Point{x: 2, y: 6}}
    assert Map.get(map, %Point{x: 4, y: 6}) == {%Point{x: 3, y: 6}, %Point{x: 4, y: 7}}
  end

  test "Given some set of input lines, load_map will do the thing it's supposed to do, this isn't a real project, stop trying to explain everything all nice and shit" do
    lines = ["......|", "-......"]

    map = Day10.load_map(lines)

    assert Map.has_key?(map, %Point{x: 6, y: 0})
    assert Map.has_key?(map, %Point{x: 0, y: 1})
  end

  test "Given a point map and a starting point on a loop of pipe, trace_route will return {:ok, length} where length is the number of elements in the pipe including S" do
    map = %{
      # %Point{x: 1, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 1, y: 2}},
      %Point{x: 2, y: 1} => {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      %Point{x: 3, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 3, y: 2}},
      %Point{x: 1, y: 2} => {%Point{x: 1, y: 1}, %Point{x: 1, y: 3}},
      %Point{x: 3, y: 2} => {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      %Point{x: 1, y: 3} => {%Point{x: 1, y: 2}, %Point{x: 2, y: 3}},
      %Point{x: 2, y: 3} => {%Point{x: 1, y: 3}, %Point{x: 3, y: 3}},
      %Point{x: 3, y: 3} => {%Point{x: 2, y: 3}, %Point{x: 3, y: 2}}
    }

    start = %Point{x: 1, y: 1}

    route = Day10.trace_route(map, start)

    assert route == {:ok, 8}

  end

  test "pull it all together for test 1" do
    lines = [
      "-L|F7",
      "7S-7|",
      "L|7||",
      "-L-J|",
      "L|-JF"
    ]

    start_point = Day10.find_start(lines)

    assert start_point == %Point{x: 1, y: 1}

    map = Day10.load_map(lines)


    assert Day10.trace_route(map, start_point) == {:ok, 8}
  end

  test "Given a map and a starting point, find_walk will return a list of elements that are involved in the walk from start to start" do
    map = %{
      # %Point{x: 1, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 1, y: 2}},
      %Point{x: 2, y: 1} => {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      %Point{x: 3, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 3, y: 2}},
      %Point{x: 1, y: 2} => {%Point{x: 1, y: 1}, %Point{x: 1, y: 3}},
      %Point{x: 3, y: 2} => {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      %Point{x: 1, y: 3} => {%Point{x: 1, y: 2}, %Point{x: 2, y: 3}},
      %Point{x: 2, y: 3} => {%Point{x: 1, y: 3}, %Point{x: 3, y: 3}},
      %Point{x: 3, y: 3} => {%Point{x: 2, y: 3}, %Point{x: 3, y: 2}}
    }

    walk = Day10.find_walk(map, %Point{x: 1, y: 1})

    assert walk == [
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 1, y: 2},
      %Point{x: 3, y: 2}, %Point{x: 1, y: 3}, %Point{x: 2, y: 3}, %Point{x: 3, y: 3}
    ]

  end

  test "Given a map with unconnected pipes, find_walk will return only the list of elements that are involved in the walk" do
    lines = [
      "-L|F7",
      "7S-7|",
      "L|7||",
      "-L-J|",
      "L|-JF"
    ]

    start_point = Day10.find_start(lines)

    map = Day10.load_map(lines)

    walk = Day10.find_walk(map, start_point)

    assert walk == [
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 1, y: 2},
      %Point{x: 3, y: 2}, %Point{x: 1, y: 3}, %Point{x: 2, y: 3}, %Point{x: 3, y: 3}
    ]
  end

  test "Given a list of Points, sort_ascending will return the list ordered by ascending x coordinate" do
    points = [%Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 1, y: 1}]

    sorted = Day10.sort_ascending(points)

    assert points == [%Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}]
  end

  test "Given a list of Points, rasterize will return a Map of points keyed by their y-coordinate and where each raster lines Points are ordered by ascending X value" do
    points = [
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 1, y: 2},
      %Point{x: 3, y: 2}, %Point{x: 1, y: 3}, %Point{x: 2, y: 3}, %Point{x: 3, y: 3}
    ]
  end

end
