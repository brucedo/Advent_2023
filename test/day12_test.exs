defmodule Day12Test do
  use ExUnit.Case
  doctest(Day12)

  test "Given a pattern of a single ? and a number 1, bind_pattern will return {:ok, ''}" do
    pattern  = "?"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of two ? and a number 1, bind_pattern will return {:ok, ''}" do
    pattern = "??"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of two ? and a number 2, bind_pattern will return {:ok, ''}" do
    pattern = "??"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of 3 ? and a number 1, bind_pattern will return {:ok, '?'}" do
    pattern = "???"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, "?"}
  end

  test "Given a pattern of 3 ? and a number 2, bind_pattern will return {:ok, ''}" do
    pattern = "???"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of 1 ? and a number 2, bind_pattern will return {:error}" do
    pattern = "?"
    number = 2

    assert Day12.bind_pattern(pattern, number) == {:error}
  end

  test "Given a pattern of 1 # and a number 1, bind_pattern will return {:ok, ''}" do
    pattern = "#"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of #? and a number 1, bind_pattern will return {:ok, ''}" do
    pattern = "#?"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of ?# and a number 1, bind_pattern will return {:error}" do
    pattern = "?#"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:error}
  end

  test "Given a pattern of ?#? and a number 1, bind_pattern will return {:ok, ''}" do
    pattern = "?#?"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, ""}
  end

  test "Given a pattern of ??# and a number 1, bind_pattern will return {:ok, '#'}" do
    pattern = "??#"
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:ok, "#"}
  end

  test "Given a pattern of '#' and a number greater than 1, bind_pattern will return {:error}" do
    pattern = "#"
    number = 2

    assert Day12.bind_pattern(pattern, number) == {:error}
  end

  test "Given a pattern of '' and a number greater than 0, bind_pattern will return {:error}" do
    pattern = ""
    number = 1

    assert Day12.bind_pattern(pattern, number) == {:error}
  end

  test "Given a pattern of '#' and a number of 0, bind_pattern will return {:error}" do
    pattern = "#"
    number = 0

    assert Day12.bind_pattern(pattern, number) == {:error}
  end

  test "Given any pattern that starts with '#' and a number of 0, bind_pattern will return {:error}" do
    pattern = "#???????#???#?#?#?#?#?#?#?#?#"
    number = 0

    assert Day12.bind_pattern(pattern, number) == {:error}
  end
end
