defmodule Day7 do
require Logger

  def run() do
    lines = Common.open(File.cwd, "day7.txt") |> Common.read_file_pipe() |> Common.close()

    partial_cards = for pair <- lines, do: (String.split(pair) |> List.to_tuple())
    cards = for pair <- partial_cards, do:  (put_elem(pair, 0, Day7.text_to_hand(elem(pair, 0))) |>
                                            put_elem(1, String.to_integer(elem(pair, 1)) ))

    sorted = Enum.sort(cards, fn {first_cards, _}, {second_cards, _} -> Day7.whole_comparison(first_cards, second_cards, false) end)

    final_score = elem(Day7.calculate_total(sorted), 0)

    IO.puts("Supposedly the final score is #{final_score}")

    sorted = Enum.sort(cards, fn {first_cards, _}, {second_cards, _} -> Day7.whole_comparison(first_cards, second_cards, true) end)

    part_2_final = elem(Day7.calculate_total(sorted), 0)

    IO.puts("and supposedly part 2 total is #{part_2_final}")

  end

  @spec joker_hand(list(atom())) :: atom()
  def joker_hand(hand) do
    jokerless = Enum.filter(hand, fn card -> card != :J end)
    joker_num = Enum.filter(hand, fn card -> card == :J end) |> Enum.count()

    bucket = if length(jokerless) > 0 do bucketize(jokerless) else %{J: 0} end
    Logger.debug("Input value: #{inspect bucket}")
    Map.values(bucket) |> Enum.sort() |> Enum.reverse() |> List.update_at(0, fn elem -> elem + joker_num end) |> Enum.reverse() |> List.to_tuple() |> hand_lookup()

  end

  @spec identify_hand(list(atom())) :: atom()

  def identify_hand(hand) do
    bucket = bucketize(hand)

    Map.values(bucket) |> Enum.sort() |> List.to_tuple() |> hand_lookup()

  end

  defp hand_lookup(hand_tuple) do
    Logger.debug("Hand tuple: #{inspect(hand_tuple)}")
    case hand_tuple do
      {5} -> :five_of_a_kind
      {1, 4} -> :four_of_a_kind
      {2, 3} -> :full_house
      {1, 1, 3} -> :three_of_a_kind
      {1, 2, 2} -> :two_pair
      {1, 1, 1, 2} -> :one_pair
      {1, 1, 1, 1, 1} -> :high_card
    end
  end

  @spec bucketize(list(atom())) :: %{}
  defp bucketize([]) do
    %{}
  end

  defp bucketize([next | rest]) do
    bucketize(rest) |> Map.get_and_update(next, fn value -> {value, if value == nil do 1 else value + 1 end} end ) |> elem(1)
  end

  @spec calculate_total(list({list(atom()), integer()})) :: {integer(), integer()}
  def calculate_total([]) do
    {0, 1}
  end

  def calculate_total([{_, bet} | rest]) do
    {total, rank} = calculate_total(rest)

    hand_total = bet * rank
    {total + hand_total, rank + 1}
  end

  @spec higher_hand(list(atom()), list(atom()), fun()) :: atom()
  def higher_hand([], [], _) do
    :equal
  end

  def higher_hand([first_card | first_hand], [second_card | second_hand], valuator) do
    first_value = valuator.(first_card)
    second_value = valuator.(second_card)

    cond do
      first_value > second_value -> :greater
      first_value == second_value -> higher_hand(first_hand, second_hand, valuator)
      first_value < second_value -> :lesser
    end
  end

  @spec whole_comparison(list(atom()), list(atom()), boolean()) :: boolean()
  def whole_comparison(left_hand, right_hand, part2) do
    equality = if part2 do higher_type(left_hand, right_hand, &joker_hand/1) else higher_type(left_hand, right_hand, &identify_hand/1) end

    valuator = if part2 do &card_value_with_joker/1 else &card_value/1 end

    equality = if equality == :equal do higher_hand(left_hand, right_hand, valuator) else equality end

    case equality do
      n when n == :greater or n == :equal -> true
      :lesser -> false
    end
  end

  def text_to_hand(hand_text) do
    for card <- String.graphemes(hand_text), do: text_to_card(card)
  end

  def text_to_card(card_text) do
    case card_text do
      "A" -> :A
      "K" -> :K
      "Q" -> :Q
      "J" -> :J
      "T" -> :T
      "9" -> :NINE
      "8" -> :EIGHT
      "7" -> :SEVEN
      "6" -> :SIX
      "5" -> :FIVE
      "4" -> :FOUR
      "3" -> :THREE
      "2" -> :TWO
    end
  end

  def card_value_with_joker(card) do
    case card do
      :A -> 14
      :K -> 13
      :Q -> 12
      :J -> 1
      :T -> 10
      :NINE -> 9
      :EIGHT -> 8
      :SEVEN -> 7
      :SIX -> 6
      :FIVE -> 5
      :FOUR -> 4
      :THREE -> 3
      :TWO -> 2
    end
  end


  def card_value(first_card) do
    case first_card do
      :A -> 14
      :K -> 13
      :Q -> 12
      :J -> 11
      :T -> 10
      :NINE -> 9
      :EIGHT -> 8
      :SEVEN -> 7
      :SIX -> 6
      :FIVE -> 5
      :FOUR -> 4
      :THREE -> 3
      :TWO -> 2
    end
  end

  @spec higher_type(list(atom()), list(atom()), fun()) :: atom()
  def higher_type(first_hand, second_hand, identifier) do
    first_rank = identifier.(first_hand) |> type_ordering()
    second_rank = identifier.(second_hand) |> type_ordering()

    cond do
      first_rank > second_rank -> :greater
      first_rank == second_rank -> :equal
      first_rank < second_rank -> :lesser
    end
  end

  def type_ordering(type) do
    case type do
      :five_of_a_kind -> 7
      :four_of_a_kind -> 6
      :full_house -> 5
      :three_of_a_kind -> 4
      :two_pair -> 3
      :one_pair -> 2
      :high_card -> 1
    end
  end

end
