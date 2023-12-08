defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Given a draw of 5 identical cards identify_hand wil return :five_of_a_kind" do
    hand = [:A, :A, :A, :A, :A]

    type = Day7.identify_hand(hand)

    assert type == :five_of_a_kind
  end

  test "Given a draw of 4 identical and one unique cards identify_hand can will return :four_of_a_kind" do
    hand = [:A, :A, :EIGHT, :A, :A]

    type = Day7.identify_hand(hand)

    assert type == :four_of_a_kind
  end

  test "Given a draw of a double and a triple of identical cards identify_hand will return :full_house " do
    hand = [:TWO, :THREE, :THREE, :THREE, :TWO]

    type = Day7.identify_hand(hand)

    assert type == :full_house
  end

  test "Given a draw of three identical and two different cards identify_hand can will return :three_of_a_kind" do
    hand = [:TEN, :TEN, :TEN, :NINE, :EIGHT]

    type = Day7.identify_hand(hand)

    assert type == :three_of_a_kind
  end

  test "Given a draw of two pairs of identical and one different card identify_cards wiil return :two_pair" do
    hand = [:TWO, :THREE, :FOUR, :THREE, :TWO]

    type = Day7.identify_hand(hand)

    assert type == :two_pair
  end

  test "Given a draw of one pair of identical and three unique cards identify_hand will return :one_pair" do
    hand = [:A, :TWO, :THREE, :A, :FOUR]

    type = Day7.identify_hand(hand)

    assert type == :one_pair
  end

  test "Given a draw of 5 unique cards identify_hand will return :high_card" do
    hand = [:TWO, :THREE, :FOUR, :FIVE, :SIX]

    type = Day7.identify_hand(hand)

    assert type == :high_card
  end

  test "Given two hands higher_hand will return :greater if the first hand is higher-valued based on card comparison" do
    first_hand = [:A, :TWO, :THREE, :FOUR, :FIVE]
    second_hand = [:FIVE, :FOUR, :THREE, :TWO, :A]

    assert Day7.higher_hand(first_hand, second_hand, &Day7.card_value/1) == :greater
  end

  test "Given two hands higher_hand will return :equal if the two hands are identical based on card comparison" do
    first_hand = [:A, :TWO, :THREE, :FOUR, :FIVE]

    assert Day7.higher_hand(first_hand, first_hand, &Day7.card_value/1) == :equal
  end

  test "Given two hands higher_hand will return :lesser if the first hand is lower-valued based on card comparison" do
    first_hand = [:FOUR, :FIVE, :SIX, :SEVEN, :EIGHT]
    second_hand = [:FIVE, :SIX, :SEVEN, :EIGHT, :NINE]

    assert Day7.higher_hand(first_hand, second_hand, &Day7.card_value/1) == :lesser
  end

  test "Given two hands higher_type will return :greater if the first hand is higher-valued based on type comparison " do
    first_hand = [:A, :A, :A, :A, :ONE]
    second_hand = [:THREE, :THREE, :THREE, :FIVE, :FIVE]

    assert Day7.higher_type(first_hand, second_hand, &Day7.identify_hand/1) == :greater
  end

  test "Give two hands higher_type will return :equal if the first hand and second hand have the same type" do
    first_hand = [:A, :A, :A, :K, :K]

    assert Day7.higher_type(first_hand, first_hand, &Day7.identify_hand/1) == :equal
  end

  test "Given two hands higher_type will return :lesser if the first hand is lower-valued based on type comparison." do
    first_hand = [:A, :TWO, :THREE, :FOUR, :FIVE]
    second_hand = [:TWO, :TWO, :THREE, :THREE, :THREE]

    assert Day7.higher_type(first_hand, second_hand, &Day7.identify_hand/1) == :lesser
  end

  test "Given any string containing solely character symbols representing a valid card, text_to_hand will return an atom-based representation of the hand" do
    string_hand = "AKQJT98765432"

    hand = Day7.text_to_hand(string_hand)

    assert hand == [:A, :K, :Q, :J, :T, :NINE, :EIGHT, :SEVEN, :SIX, :FIVE, :FOUR, :THREE, :TWO]
  end

  test "Dry run of the part 1 process " do
    hand_and_bid = ["32T3K 765", "T55J5 684", "KK677 28", "KTJJT 220", "QQQJA 483"]

    partial_cards = for pair <- hand_and_bid, do: (String.split(pair) |> List.to_tuple())
    cards = for pair <- partial_cards, do:  (put_elem(pair, 0, Day7.text_to_hand(elem(pair, 0))) |>
                                            put_elem(1, String.to_integer(elem(pair, 1)) ))

    assert cards == [
      {[:THREE, :TWO, :T, :THREE, :K], 765},
      {[:T, :FIVE, :FIVE, :J, :FIVE], 684},
      {[:K, :K, :SIX, :SEVEN, :SEVEN], 28},
      {[:K, :T, :J, :J, :T], 220},
      {[:Q, :Q, :Q, :J, :A], 483}
    ]

    sorted = Enum.sort(cards, fn {first_cards, _}, {second_cards, _} -> Day7.whole_comparison(first_cards, second_cards, false) end)

    assert sorted == [
      {[:Q, :Q, :Q, :J, :A], 483},
      {[:T, :FIVE, :FIVE, :J, :FIVE], 684},
      {[:K, :K, :SIX, :SEVEN, :SEVEN], 28},
      {[:K, :T, :J, :J, :T], 220},
      {[:THREE, :TWO, :T, :THREE, :K], 765}
    ]

    assert elem(Day7.calculate_total(sorted), 0) == 6440

  end

  test "given a two of a kind hand with two jokers joker_hand will upcast it to four of a kind" do
    hand = [:K, :T, :J, :J, :T]

    assert Day7.joker_hand(hand) == :four_of_a_kind
  end

  test "given a high_card hand with two jokers joker_hand will upcast it to three_of_a_kind" do
    hand = [:K, :T, :J, :J, :Q]

    assert Day7.joker_hand(hand) == :three_of_a_kind
  end

  test "given a hgih_card hand with one joker joker_hand will upcast it to one pair" do
    hand = [:K, :T, :J, :EIGHT, :Q]

    assert Day7.joker_hand(hand) == :one_pair
  end

  test "Given a three of a kind with one joker joker_hand will upcast it to four of a kind" do
    hand = [:K, :K, :J, :T, :K]

    assert Day7.joker_hand(hand) == :four_of_a_kind
  end

  test "part 2 - give it a whirl" do
    hand_and_bid = ["32T3K 765", "T55J5 684", "KK677 28", "KTJJT 220", "QQQJA 483"]

    partial_cards = for pair <- hand_and_bid, do: (String.split(pair) |> List.to_tuple())
    cards = for pair <- partial_cards, do:  (put_elem(pair, 0, Day7.text_to_hand(elem(pair, 0))) |>
                                            put_elem(1, String.to_integer(elem(pair, 1)) ))

    assert cards == [
      {[:THREE, :TWO, :T, :THREE, :K], 765},
      {[:T, :FIVE, :FIVE, :J, :FIVE], 684},
      {[:K, :K, :SIX, :SEVEN, :SEVEN], 28},
      {[:K, :T, :J, :J, :T], 220},
      {[:Q, :Q, :Q, :J, :A], 483}
    ]

    sorted = Enum.sort(cards, fn {first_cards, _}, {second_cards, _} -> Day7.whole_comparison(first_cards, second_cards, true) end)

    assert sorted == [
      {[:K, :T, :J, :J, :T], 220},
      {[:Q, :Q, :Q, :J, :A], 483},
      {[:T, :FIVE, :FIVE, :J, :FIVE], 684},
      {[:K, :K, :SIX, :SEVEN, :SEVEN], 28},
      {[:THREE, :TWO, :T, :THREE, :K], 765},
    ]

    assert assert elem(Day7.calculate_total(sorted), 0) == 5905
  end

end
