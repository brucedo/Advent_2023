defmodule Day10Test do
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
    pipe_endpionts = Day10.tile_to_points(%Point(x: 5, y: 5), "F")

    assert pipe_endpoints == {%Point{x: 6 y: 5}, %Point{x: 5, y: 6}}
  end

end
