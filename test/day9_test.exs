defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "Given a sequence of numbers, compute_step will compute the difference between each number in the sequence " do
    sequence = [10, 13, 16, 21, 30, 45]

    difference = Day9.compute_step(sequence)

    assert difference == [3, 3, 5, 9, 15]
  end

  test "Given a sequence of numbers that are all 0s, all_zero? will return true" do
    sequence = [0, 0, 0, 0, 0]

    zerod = Day9.all_zero?(sequence)

    assert zerod
  end

  test "Given a sequence of numbers of which at least one is non-zero, all_zero? will return false" do
    sequence = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 1]
    zerod = Day9.all_zero?(sequence)

    assert zerod == false

  end

  test "Given an input sequence calculate_deltas will produce a list composed of the input sequence and each set of steps including the all zeros step" do
    sequence = [1, 3, 6, 10, 15, 21]

    deltas = Day9.compute_deltas(sequence)

    assert deltas == [[1, 3, 6, 10, 15, 21], [2, 3, 4, 5, 6], [1, 1, 1, 1], [0, 0, 0]]
  end

  test "Given a list of deltas, tails will pull the last digit off of each delta and return it ordered from the 0 delta to the last digit of the original list" do
    deltas = [[1, 3, 6, 10, 15, 21], [2, 3, 4, 5, 6], [1, 1, 1, 1], [0, 0, 0]]

    tails = Day9.tails(deltas)

    assert tails == [0, 1, 6, 21]
  end

  test "Given a list of deltas, heads will pull the first digit off of each delta and return it ordered from the 0 delta to the last digit of the original list" do
    deltas = [[10,  13,  16,  21,  30,  45], [3, 3, 5, 9, 15], [0, 2, 4, 6], [2, 2, 2], [0, 0]]

    heads = Day9.heads(deltas)

    assert heads == [0, 2, 0, 3, 10]
  end

  test "Given a list of tails, compute_next_step will produce the next value for the originating list" do
    tails = [0, 1, 6, 21]

    next_step = Day9.compute_next_step(tails)

    assert next_step == 28
  end

  test "Given a list of heads, compute_prev_step will prduce the preceding value for the original list of measurements" do
    heads = [0, 2, 0, 3, 10]

    prev_step = Day9.compute_prev_step(heads)

    assert prev_step == 5
  end

  test "Tie part 1 all together" do
    lines = ["0 3 6 9 12 15", "1 3 6 10 15 21", "10 13 16 21 30 45"]
    numbers = Enum.map(lines, fn line -> String.split(line) |> Enum.map(fn str_num -> String.to_integer(str_num) end) end)

    next_steps = for variable_list <- numbers, do: (Day9.compute_deltas(variable_list) |> Day9.tails |> Day9.compute_next_step)

    assert Enum.sum(next_steps) == 114
  end

  test "Tie part 2 all together" do
    lines = ["0 3 6 9 12 15", "1 3 6 10 15 21", "10 13 16 21 30 45"]
    numbers = Enum.map(lines, fn line -> String.split(line) |> Enum.map(fn str_num -> String.to_integer(str_num) end) end)

    prev_steps = for variable_list <- numbers, do: (Day9.compute_deltas(variable_list) |> Day9.heads |> Day9.compute_prev_step)

    assert Enum.sum(prev_steps) == 2
  end
end
