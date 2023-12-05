defmodule Day4 do

  def run() do
    lines = Common.open(File.cwd, "day4.txt") |> Common.read_file_pipe() |> Common.close()

    results = for line <- lines, do: Day4.split_line(line) |> Day4.do_the_things()

    final_tally = Enum.filter(results, fn r -> r != 0 end) |> Enum.map(fn r -> Integer.pow(2, (r - 1)) end) |> Enum.sum()

    IO.puts("The final tally should be #{final_tally}")

    part_2_line_chunks = for line <- lines, do: Day4.split_line(line)

    count_map = do_the_things_part_2(part_2_line_chunks)

    scratch_card_total = Map.values(count_map) |> Enum.sum()
    IO.puts("The finished total count of all won scratch cards is theoretically #{scratch_card_total}")

  end

  @spec do_the_things_part_2(list(map())) :: map()
  def do_the_things_part_2(parsed_lines) do
    count_map = initialize_count(parsed_lines)

    Enum.reduce(parsed_lines, count_map, fn elem, acc -> count_and_increment(elem, acc) end)

  end

  def count_and_increment(line_map, counting_map) do
    card = Map.get(line_map, "card") |> String.split()
    card = List.first(card) <> " " <> List.last(card)

    card_number = String.split(card) |> List.last() |> String.to_integer(10)

    winners = Map.get(line_map, "winners") |> number_splitter |> number_converter() |> setify_winners()
    potentials = Map.get(line_map, "prospective") |> number_splitter |> number_converter()

    card_count = Map.get(counting_map, card)

    case count_winners(potentials, winners) do
      0 -> counting_map
      win_count -> 1..win_count
          |> Enum.map(fn card_no -> "Card #{Integer.to_string(card_number + card_no)}" end)
          |> Enum.reduce(counting_map, fn key, cm -> (Map.get_and_update(cm, key, fn val -> {val, val + card_count} end)) |> elem(1) end)

    end

  end

  @spec initialize_count(list(map())) :: map()
  def initialize_count(parsed_lines) do
    keys = for line <- parsed_lines, do: (Map.get(line, "card")
                                          |> String.split()
                                          |> List.foldl("", fn elem, acc -> acc <> elem <> " " end)
                                          |> String.trim())
    Enum.reduce(keys, %{}, fn elem, acc -> Map.put(acc, elem, 1) end)
    # Enum.reduce(parsed_lines, %{}, fn elem, acc -> Map.put(acc, Map.get(elem, "card"), 1) end)
  end

  @spec do_the_things(map()) :: integer()
  def do_the_things(line_parts) do
    _card_name = Map.get(line_parts, "card")
    winners = Map.get(line_parts, "winners") |> number_splitter |> number_converter() |> setify_winners()
    potential_winners = Map.get(line_parts, "prospective") |> number_splitter |> number_converter()

    count_winners(potential_winners, winners)

  end

  @spec card_number(String.t()) :: integer()
  def card_number(card_segment) do
    Regex.named_captures(~r/Card (?<number>[0-9]+)/, card_segment) |> Map.get("number") |> Integer.parse() |> elem(0)
  end

  @spec number_splitter(String.t()) :: list(String.t())
  def number_splitter(raw_numbers) do
    String.trim(raw_numbers) |> String.split()
  end

  @spec number_converter(list(String.t())) :: list(integer())
  def number_converter(prospective_winners) do
    for prospective <- prospective_winners, do: Integer.parse(prospective) |> elem(0)
  end

  @spec setify_winners(list(integer())) :: MapSet.t(integer())
  def setify_winners(winning_numbers) do
    MapSet.new(winning_numbers)
  end

  @spec count_winners(list(integer()), MapSet.t(integer())) :: integer()
  def count_winners(potential_winners, winning_set) do
    Enum.filter(potential_winners, fn elem -> MapSet.member?(winning_set, elem) end)
      |> Enum.count()
  end

  @spec split_line(String.t()) :: %{}
  def split_line(line) do
    Regex.named_captures(~r/(?<card>.*):(?<winners>.*) \|(?<prospective>.*)/, line)
  end


end
