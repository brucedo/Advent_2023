defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "Given some game line then decode() will return a completed Game typestruct whose draws list contains the shown Cube color counts for each draw" do
    input = "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"

    game = Day2.decode(input)

    assert game == %Game{game_id: 2, draws: [%Draw{red: 0, blue: 1, green: 2}, %Draw{red: 1, blue: 4, green: 3}, %Draw{red: 0, blue: 1, green: 1}]}
  end

  test "Given some game partition of an input line, decode_game will return a Game object with an empty draws list and the ID set" do
    input = "Game 3"

    game = Day2.decode_game(input)

    assert game == %Game{game_id: 3, draws: []}

  end

  test "Given some draws partition of an input line, decode_draws will return a list of Draw objects" do
    input = " 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"

    draws = Day2.decode_draws(input)

    assert draws == [%Draw{red: 20, blue: 6, green: 8}, %Draw{red: 4, blue: 5, green: 13}, %Draw{red: 1, blue: 0, green: 5}]
  end

  test "Given some single draw input, decode_draw will return a single Draw object" do
    input = " 5 blue, 4 red, 13 green"

    draw = Day2.decode_draw(input)

    assert draw == %Draw{red: 4, blue: 5, green: 13}
  end

  test "Given a full input line, slice_game will return a tuple comprised of the game number substring in elem 1, and the draws in elem 2" do
    input = "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"

    slices = Day2.slice_game(input)

    assert slices == {"Game 4", " 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"}
  end

  test "Given the draws portion of a game line, slice_draws will return a list of substrings comprised of each individual cube draw result" do
    input = "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"

    draws = Day2.slice_draws(input)

    assert draws == ["1 green, 3 red, 6 blue", " 3 green, 6 red",  " 3 green, 15 blue, 14 red"]
  end

end
