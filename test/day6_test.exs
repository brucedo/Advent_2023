defmodule Day6Test do
  require Logger
  use ExUnit.Case
  doctest Day6

  test "part1_distance will take some pair of parameters and return the distance as a funciton of (p1 - p2) * p2 " do
    part1_dist = Day6.part1_distance(7, 3)

    assert part1_dist == 12
  end

  test "Given a two parameter function, a sequence of inputs and a halting threshold, distance_calculator will return the inputs whose result does not fall below the threshold" do
    sequence = [{7, 3}, {7, 2}, {7, 1}, {7, 0} ]

    viable_times = Day6.distance_calculator(sequence, &Day6.part1_distance/2, 9)

    assert viable_times == [{7, 3}, {7, 2}]
  end

  test "Given a single integer, make_test_ranges will produce a pair of lists of tuples {c, n} where c is the parameter and n is some value in the range 0..c/2 or c/2+1..c" do
    ranges = Day6.make_test_ranges(7)

    assert ranges == {[{7, 3}, {7, 2}, {7, 1}, {7, 0}], [{7, 4}, {7, 5}, {7, 6}, {7, 7}]}
  end

  test "Given the test input time and distance lines, I should receive 4 + 8 + 9 individual pairs back from calculate_races" do
    time = Day6.convert_line_to_numbers("Time:      7  15   30")
    dist = Day6.convert_line_to_numbers("Distance:  9  40  200")

    completed = Day6.calculate_races(time, dist)
    Logger.debug("#{inspect completed}")
    lengths = Enum.map(completed, fn sublist -> length(sublist) end)
    Logger.debug("ehhhh #{inspect lengths}")

    assert Enum.product(lengths) == 4 * 8 * 9
  end

  test "Do the dekern version for part 2" do
    time = Day6.dekern_lines("Time:      7  15   30")
    dist = Day6.dekern_lines("Distance:  9  40  200")

    completed = Day6.calculate_races([time], [dist])

    lengths = Enum.map(completed, fn sublist -> length(sublist) end)
    Logger.debug("dekern lengths: #{inspect lengths}")
  end

  test "binary_search will find the smallest time that passes the distance test" do
    time = 71530
    dist = 940200

    smallest_time = Day6.binary_search(0, time, time, dist, false)
    Logger.debug("#{inspect smallest_time}")

    assert Day6.beats_distance?(time, smallest_time, dist) != Day6.beats_distance?(time, smallest_time - 1, dist)
  end

  test "binary_search will find the largest time that passes the distance test if invert_search is true" do
    time = 71530
    dist = 940200

    largest_time = Day6.binary_search(0, time, time, dist, true)
    Logger.debug("#{inspect largest_time}")

    assert Day6.beats_distance?(time, largest_time, dist) != Day6.beats_distance?(time, largest_time + 1, dist)
  end

  test "total range then can be calculated as such" do
    time = 71530
    dist = 940200

    smallest_time = Day6.binary_search(0, time, time, dist, false)
    largest_time = Day6.binary_search(0, time, time, dist, true)

    total_range = largest_time - smallest_time + 1

    assert total_range == 71503
  end

end
