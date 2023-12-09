defmodule Day8Test do
  use ExUnit.Case
  doctest Day8


  test "when given a pair that is a map of nodes and a sequence of choices that lead to ZZZ, solve_path will return {:ok, step_count} where step_count is the number of steps needed to follow to exit" do
    map = %{AAA: {:BBB, :CCC}, BBB: {:DDD, :EEE}, CCC: {:ZZZ, :GGG}, DDD: {:DDD, :DDD}, EEE: {:EEE, :EEE}, GGG: {:GGG, :GGG}, ZZZ: {:ZZZ, :ZZZ}}
    path = ["R", "L"]

    assert Day8.solve_path(map, path, [:AAA]) == {:ok, 2}
  end

  test "when given a pair that is a map of nodes and a sequence of choices that do NOT lead to ZZZ, solve_path will return {:error, last_node} where last_node is the name of the last node visited" do
    map = %{AAA: {:BBB, :CCC}, BBB: {:DDD, :EEE}, CCC: {:ZZZ, :GGG}, DDD: {:DDD, :DDD}, EEE: {:EEE, :EEE}, GGG: {:GGG, :GGG}, ZZZ: {:ZZZ, :ZZZ}}
    path = ["L", "R"]

    assert Day8.solve_path(map, path, [:AAA]) == {:error, [:EEE]}
  end

  # test "when given a pair that is a map of nodes and a sequence of choices that lead to an infinite loop, solve_maze will return {:err, :unsolvable}" do
  #   map = %{AAA: {:BBB, :CCC}, BBB: {:DDD, :EEE}, CCC: {:ZZZ, :GGG}, DDD: {:DDD, :DDD}, EEE: {:EEE, :EEE}, GGG: {:GGG, :GGG}, ZZZ: {:ZZZ, :ZZZ}}
  #   path = ["L", "R"]

  #   assert Day8.solve_maze(map, path) == {:error, :unsolvable}
  # end

  test "when given a pair that is a map of nodes and a sequence of choices that will solve the map on the first pass, solve_maze will return {:ok, step_count}" do
    map = %{AAA: {:BBB, :CCC}, BBB: {:DDD, :EEE}, CCC: {:ZZZ, :GGG}, DDD: {:DDD, :DDD}, EEE: {:EEE, :EEE}, GGG: {:GGG, :GGG}, ZZZ: {:ZZZ, :ZZZ}}
    path = ["R", "L"]

    assert Day8.solve_maze(map, path) == {:ok, 2}
  end

  test "when given a pair that is a map of nodes and a sequence of choices that will eventually solve the map, solve_maze will return {:ok, step_count}" do
    map = %{AAA: {:BBB, :BBB}, BBB: {:AAA, :ZZZ}, ZZZ: {:ZZZ, :ZZZ}}
    path = ["L", "L", "R"]

    assert Day8.solve_maze(map, path) == {:ok, 6}
  end

  test "Given a list of input lines make_map will convert them into an atom-based node map" do
    lines = ["AAA = (BBB, CCC)",
    "BBB = (DDD, EEE)",
    "CCC = (ZZZ, GGG)",
    "DDD = (DDD, DDD)",
    "EEE = (EEE, EEE)",
    "GGG = (GGG, GGG)",
    "ZZZ = (ZZZ, ZZZ)"]

    map = Day8.make_map(lines)

    assert map == %{AAA: {:BBB, :CCC}, BBB: {:DDD, :EEE}, CCC: {:ZZZ, :GGG}, DDD: {:DDD, :DDD}, EEE: {:EEE, :EEE}, GGG: {:GGG, :GGG}, ZZZ: {:ZZZ, :ZZZ}}
  end

  test "Given some list of nodes all of which end in Z, done? will return true" do
    nodes = [:ONEONEZ, :TWOTWOZ, :THREETHREEZ, :ZZZ]

    assert Day8.done?(nodes)
  end

  test "Given some list of nodes at least one of which does not end in Z, done? will return false" do
    nodes = [:ONEONEZ, :TWOTWO, :THREETHREE, :ZZZ]

    assert !Day8.done?(nodes)
  end

  test "Given a map filled with node relationships, find_start_set will find the list of all atoms that start with A" do
    map = %{:ZZA => {:BAB, :CAC}, :ZAZ => {:CCA, :CCC}, :BAB => {:ZZA, :ZAZ}, :CAC => {:CCA, :CCC}, :AAA => {:CCA, :CCC}, :CCA => {:AAA, :CCC}}

    assert Day8.find_start_set(map) |> Enum.sort() == [:AAA, :CCA, :ZZA]
  end

  test "Try this with a part 2 equivalent dataset now..." do
    map = %{:OOA => {:OOB, :XXX}, :OOB => {:XXX, :OOZ}, :OOZ => {:OOB, :XXX},
            :TTA => {:TTB, :XXX}, :TTB => {:TTC, :TTC}, :TTC => {:TTZ, :TTZ},
            :TTZ => {:TTB, :TTB}, :XXX => {:XXX, :XXX}}
    path = ["L", "R"]

    assert Day8.solve_maze(map, path) == {:ok, 6}
  end

end
