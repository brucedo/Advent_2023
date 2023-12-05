defmodule Day4Test do
  require Logger
  use ExUnit.Case
  doctest Day4

  test "Just gonna do the whole thing, part 1 looks pretty straightforward" do
    input_set = ["Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
                  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
                  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
                  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
                  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
                  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"]

    results = for line <- input_set, do: Day4.split_line(line) |> Day4.do_the_things()

    final_tally = Enum.filter(results, fn r -> r != 0 end) |> Enum.map(fn r -> Integer.pow(2, (r - 1)) end) |> Enum.sum()

    Logger.debug("The results are #{inspect(results)}, with a final tally of #{final_tally}")

  end

  test "Part 2 initializer test..." do
    input_set = ["Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
                  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
                  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
                  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
                  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
                  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"]

    results = for line <- input_set, do: Day4.split_line(line)

    assert Day4.initialize_count(results) == %{"Card 1"=>1, "Card 2"=>1, "Card 3"=>1, "Card 4"=>1, "Card 5"=>1, "Card 6"=>1}

  end

  test "Part 2 count and update map: test adding the results of a card with no copies" do
    input_set = ["Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
                  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
                  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
                  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
                  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
                  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"]

    decoded_lines = for line <- input_set, do: Day4.split_line(line)

    count_map = Day4.initialize_count(decoded_lines)

    [first_line | all_rest] = decoded_lines
    Logger.debug("Is first line anything? #{inspect( first_line)}")

    count_map = Day4.count_and_increment(first_line, count_map)

    assert count_map == %{"Card 1"=>1, "Card 2"=>2, "Card 3"=>2, "Card 4"=>2, "Card 5"=>2, "Card 6"=>1}
    Logger.debug("#{inspect(count_map)}")

  end

  test "Part 2 count and update map: test adding a winning card with copies" do
    input_set = ["Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
                  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
                  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
                  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
                  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"]

    decoded_lines = for line <- input_set, do: Day4.split_line(line)

    count_map = %{"Card 1"=>1, "Card 2"=>2, "Card 3"=>2, "Card 4"=>2, "Card 5"=>2, "Card 6"=>1}

    [first_line | all_rest] = decoded_lines

    count_map = Day4.count_and_increment(first_line, count_map)

    assert count_map == %{"Card 1"=>1, "Card 2"=>2, "Card 3"=>4, "Card 4"=>4, "Card 5"=>2, "Card 6"=>1}
    Logger.debug("#{inspect(count_map)}")
  end

  test "Part 2 full suite test of the entire test contents" do
    input_set = ["Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
                  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
                  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
                  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
                  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
                  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"]

    decoded_lines = for line <- input_set, do: Day4.split_line(line)

    count_map = Day4.do_the_things_part_2(decoded_lines)

    assert count_map == %{"Card 1"=>1, "Card 2"=>2, "Card 3"=>4, "Card 4"=>8, "Card 5"=>14, "Card 6"=>1}

    Logger.debug("#{inspect(count_map)}")
  end

end
