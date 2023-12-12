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

  test "Given a map and a starting point, find_walk will return the list of non-horizonal elements that are involved in the walk from start to start" do
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
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}
    ]

  end

  test "Given a map with unconnected pipes, find_walk will return only the list of non-horizontal elements that are involved in the walk" do
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
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}
    ]
  end

  test "Given a list of Points, sort_ascending will return the list ordered by ascending x coordinate" do
    points = [%Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 1, y: 1}]

    sorted = Day10.sort_ascending(points)

    assert sorted == [%Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}]
  end

  test "Given a list of Points, rasterize will return a Map of points keyed by their y-coordinate and where each raster lines Points are ordered by ascending X value" do
    points = [
      %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 1, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 1, y: 2}, %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}
    ]

    sorted = Day10.rasterize(points)

    assert Map.get(sorted, 1) == [%Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}]
    assert Map.get(sorted, 2) == [%Point{x: 1, y: 2}, %Point{x: 3, y: 2}]
    assert Map.get(sorted, 3) == [%Point{x: 1, y: 3}, %Point{x: 2, y: 3}, %Point{x: 3, y: 3}]
  end

  test "Given a map and a walk, infer_start will fill in the S field with an inferred value based on the start and end of the walk " do
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
    walk = [
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}
    ]

    updated_map = Day10.infer_start(map, walk)

    assert Map.get(updated_map, %Point{x: 1, y: 1}) == {%Point{x: 2, y: 1}, %Point{x: 1, y: 2}}
  end

  test "Given a map and a corner value is_corner will return true" do
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

    corner = %Point{x: 3, y: 1}

    assert Day10.is_corner?(map, corner)
  end

  test "Given a map and a vertical line is_corner will return false" do
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

    vertical = %Point{x: 3, y: 2}

    refute Day10.is_corner?(map, vertical)

  end

  test "Given a map and a horizontal line is_corner will return false " do
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

    horizontal = %Point{x: 2, y: 1}

    refute Day10.is_corner?(map, horizontal)

  end

  test "Given a walk that starts on an edge, rotate_to_corner will advance the head of the walk to the next corner" do
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

    walk = [
      %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}, %Point{x: 1, y: 1}
    ]

    assert Day10.rotate_to_corner(map, walk) == [
      %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}, %Point{x: 1, y: 1}, %Point{x: 2, y: 1}
    ]
  end

  test "Given a walk and a map, start_segment will produce a list of Point pairs except for the last, where each pair is a line in the polygon" do
    map = %{
      %Point{x: 1, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 1, y: 2}},
      %Point{x: 2, y: 1} => {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      %Point{x: 3, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 3, y: 2}},
      %Point{x: 1, y: 2} => {%Point{x: 1, y: 1}, %Point{x: 1, y: 3}},
      %Point{x: 3, y: 2} => {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      %Point{x: 1, y: 3} => {%Point{x: 1, y: 2}, %Point{x: 2, y: 3}},
      %Point{x: 2, y: 3} => {%Point{x: 1, y: 3}, %Point{x: 3, y: 3}},
      %Point{x: 3, y: 3} => {%Point{x: 2, y: 3}, %Point{x: 3, y: 2}}
    }
    walk = [
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}
    ]

    polylines = Day10.start_segment(map, walk)

    assert polylines == [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}}
    ]

  end

  test "Given a walk and a map, find_polygon will produce a list of Point pairs representing all lines in the walk" do
    map = %{
      %Point{x: 1, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 1, y: 2}},
      %Point{x: 2, y: 1} => {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      %Point{x: 3, y: 1} => {%Point{x: 2, y: 1}, %Point{x: 3, y: 2}},
      %Point{x: 1, y: 2} => {%Point{x: 1, y: 1}, %Point{x: 1, y: 3}},
      %Point{x: 3, y: 2} => {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      %Point{x: 1, y: 3} => {%Point{x: 1, y: 2}, %Point{x: 2, y: 3}},
      %Point{x: 2, y: 3} => {%Point{x: 1, y: 3}, %Point{x: 3, y: 3}},
      %Point{x: 3, y: 3} => {%Point{x: 2, y: 3}, %Point{x: 3, y: 2}}
    }
    walk = [
      %Point{x: 1, y: 1}, %Point{x: 2, y: 1}, %Point{x: 3, y: 1}, %Point{x: 3, y: 2},
      %Point{x: 3, y: 3}, %Point{x: 2, y: 3}, %Point{x: 1, y: 3}, %Point{x: 1, y: 2}
    ]

    polylines = Day10.find_polygon(map, walk)

    assert polylines == [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]
  end

  test "Given a closed polygon, count_crossings will return 0 if the y-raster does not actually intersect the polygon" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(0, 2, polygon)

    assert crossings == 0
  end

  test "Given a closed polygon, count_crossings will return 1 if the y-raster crosses one line segment before the x-intercept is met" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(2, 2, polygon)

    assert crossings == 1
  end

  test "Given a closed polygon, count_crossings will return 2 if the y-raster crosses two line segments before the x-intercept is met" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(2, 4, polygon)

    assert crossings == 2
  end

  test "Given a closed polygon, count_crossings will return 2 if the y-raster crosses two line segments at the top separated by a horizontal boundary" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(1, 4, polygon)

    assert crossings == 2
  end

  test "Given a closed polygon, count_crossings will return 1 if the y-raster crosses one vertical line segment followed by a horizontal line" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(1, 2, polygon)

    assert crossings == 1
  end

  test "Given a closed polygon, count_crossings will return 0 if the y-raster crosses two line segments at the bottom separated by a horizontal boundary" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(3, 4, polygon)

    assert crossings == 0
  end

  test "Given a closed polygon, count_crossings will return 0 if the y-raster crosses one vertical line segment followed by a horizontal line at the bottom of the segment" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(3, 2, polygon)

    assert crossings == 0
  end

  test "Given a closed polygon, count_crossings will return 1 if the y-raster passes through at least one vertical line and the x-intercept coincides with the first vertical line" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    crossings = Day10.count_crossings(1, 1, polygon)

    assert crossings == 1
  end

  test "Given a closed polygon, is_point_in_pipe will return true if the point is colinear with a horizontal segment of the pipe" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 2, y: 1})

    assert colinear
  end

  test "Given a closed polygon, is_point_in_pipe will return true if the point is colinear with a vertical segment of the pipe" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 1, y: 2})

    assert colinear
  end

  test "Given a closed polygon, is_point_in_pipe will return true if the point is coincident with a corner vertex of the pipe" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 1, y: 1})

    assert colinear
  end

  test "Given a closed polygon, is_point_in_pipe will return false if the point lies above the polygon " do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 2, y: 0})

    refute colinear
  end

  test "Given a closed polygon, is_point_in_pipe will return false if the point lies to the right of the polygon" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 4, y: 2})

    refute colinear
  end

  test "Given a closed polygion, is_point_in_pipe will return false if the poine lies to the left of the polygon" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 0, y: 2})

    refute colinear
  end

  test "Given a closed polygon, is_point_in_pipe will return false if the point lies below the polygon" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 2, y: 4})

    refute colinear
  end

  test "Given a closed polygon, is_point_in_pipe will return false if the point lies inside the polygon" do
    polygon = [
      {%Point{x: 1, y: 1}, %Point{x: 3, y: 1}},
      {%Point{x: 3, y: 1}, %Point{x: 3, y: 3}},
      {%Point{x: 3, y: 3}, %Point{x: 1, y: 3}},
      {%Point{x: 1, y: 3}, %Point{x: 1, y: 1}}
    ]

    colinear = Day10.is_point_in_pipe?(polygon, %Point{x: 2, y: 2})

    refute colinear
  end

  test "Start tying this together" do
    lines = [ "...........", ".S-------7.", ".|F-----7|.",  ".||.....||.",
              ".||.....||.",  ".|L-7.F-J|.",  ".|..|.|..|.",  ".L--J.L--J.", "..........."]

    map = Day10.load_map(lines)
    start = Day10.find_start(lines)
    walk = Day10.find_walk(map, start)
    map_with_start = Day10.infer_start(map, walk)
    walk = Day10.rotate_to_corner(map_with_start, walk)
    polygon = Day10.find_polygon(map_with_start, walk)

    refute Day10.is_point_in_pipe?(polygon, %Point{x: 2, y: 6})
    assert Integer.mod(Day10.count_crossings(6, 2, polygon), 2) == 1
    assert Integer.mod(Day10.count_crossings(6, 3, polygon), 2) == 1
    assert Integer.mod(Day10.count_crossings(6, 7, polygon), 2) == 1
    assert Integer.mod(Day10.count_crossings(6, 8, polygon), 2) == 1
    assert Integer.mod(Day10.count_crossings(6, 5, polygon), 2) == 0

    analysis = for x <- 0..10, y <- 0..8, do: {Day10.count_crossings(y, x, polygon), Day10.is_point_in_pipe?(polygon, %Point{x: x, y: y})}

    inside = Enum.filter(analysis, fn {_, inside} -> !inside end) |> Enum.filter(fn {crossing, _} -> crossing != 0 && Integer.mod(crossing, 2) != 0 end)

    Logger.debug("#{inspect inside}")

    assert Enum.count(inside) == 4

  end

  test "Try second diagram..." do
    lines = [
              "..........", ".S------7.", ".|F----7|.", ".||OOOO||.",
              ".||OOOO||.", ".|L-7F-J|.", ".|II||II|.", ".L--JL--J.", ".........."]

      map = Day10.load_map(lines)
      start = Day10.find_start(lines)
      walk = Day10.find_walk(map, start)
      map_with_start = Day10.infer_start(map, walk)
      walk = Day10.rotate_to_corner(map_with_start, walk)
      polygon = Day10.find_polygon(map_with_start, walk)

      analysis = for x <- 0..9, y <- 0..8, do: {Day10.count_crossings(y, x, polygon), Day10.is_point_in_pipe?(polygon, %Point{x: x, y: y})}

      inside = Enum.filter(analysis, fn {_, inside} -> !inside end) |> Enum.filter(fn {crossing, _} -> crossing != 0 && Integer.mod(crossing, 2) != 0 end)

      Logger.debug("#{inspect inside}")
      assert Enum.count(inside) == 4
  end

  test "Try third diagram..." do
    lines = [ ".F----7F7F7F7F-7....", ".|F--7||||||||FJ....", ".||.FJ||||||||L7....", "FJL7L7LJLJ||LJ.L-7..",
              "L--J.L7...LJS7F-7L7.", "....F-J..F7FJ|L7L7L7", "....L7.F7||L7|.L7L7|", ".....|FJLJ|FJ|F7|.LJ",
              "....FJL-7.||.||||...", "....L---J.LJ.LJLJ..."]

    map = Day10.load_map(lines)
    start = Day10.find_start(lines)
    walk = Day10.find_walk(map, start)
    map_with_start = Day10.infer_start(map, walk)
    walk = Day10.rotate_to_corner(map_with_start, walk)
    polygon = Day10.find_polygon(map_with_start, walk)

    height = length(lines)
    width = List.first(lines) |> String.length()

    analysis = for x <- 0..width - 1, y <- 0..height - 1, do: {Day10.count_crossings(y, x, polygon), Day10.is_point_in_pipe?(polygon, %Point{x: x, y: y})}

    inside = Enum.filter(analysis, fn {_, inside} -> !inside end) |> Enum.filter(fn {crossing, _} -> crossing != 0 && Integer.mod(crossing, 2) != 0 end)

    Logger.debug("#{inspect inside}")
    assert Enum.count(inside) == 8
  end

end
