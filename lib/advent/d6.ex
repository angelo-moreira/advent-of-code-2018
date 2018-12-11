defmodule Advent.D6 do
  def part1() do
    coordinates =
      "inputs/d6_test.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&(String.split(&1, ", ", trim: true) |> List.to_tuple()))
      |> Enum.map(fn {column, row} -> {String.to_integer(column), String.to_integer(row)} end)
      |> Enum.with_index(1)

    max_column = coordinates |> Enum.map(fn {{column, _}, _} -> column end) |> Enum.max()
    max_row = coordinates |> Enum.map(fn {{_, row}, _} -> row end) |> Enum.max()

    for board_column <- 0..max_column, board_row <- 0..max_row do
      taxicab_distance({board_column, board_row}, coordinates)
    end
  end

  def taxicab_distance({board_column, board_row} = _board_coordinate, coordinates) do
    closest_to =
      coordinates
      |> Enum.map(fn {{column, row}, index} ->
        {column - board_column + (row - board_row), index}
      end)
      |> closest()

    {board_column, board_row, closest_to}
  end

  def closest(distances) do
    {_distance, how_many} = distances |> Enum.group_by(&elem(&1, 0)) |> Enum.at(0)

    if length(how_many) == 1 do
      [{_distance, index}] = how_many
      index
    else
      "."
    end
  end
end