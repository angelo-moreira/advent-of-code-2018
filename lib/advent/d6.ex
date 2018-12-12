defmodule Advent.D6 do
  def part1() do
    coordinates =
      "inputs/d6.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&(String.split(&1, ", ", trim: true) |> List.to_tuple()))
      |> Enum.map(fn {column, row} -> {String.to_integer(column), String.to_integer(row)} end)
      |> Enum.with_index(1)

    max_column = coordinates |> Enum.map(fn {{column, _}, _} -> column end) |> Enum.max()
    max_row = coordinates |> Enum.map(fn {{_, row}, _} -> row end) |> Enum.max()

    coordinates
    |> new_board(max_column, max_row)
    |> remove_coordinates_from_the_edge(max_column, max_row)
    |> biggest_area()
  end

  def biggest_area(board) do
    board
    |> Enum.group_by(fn {_, _, index} -> index end)
    |> Enum.map(fn {index, matches} -> {length(matches), index} end)
    |> Enum.max()
    |> elem(0)
  end

  def new_board(coordinates, max_column, max_row) do
    for board_column <- 0..max_column,
        board_row <- 0..max_row,
        do: taxicab_distance({board_column, board_row}, coordinates)
  end

  def remove_coordinates_from_the_edge(board, max_column, max_row) do
    infinite_points =
      board
      |> Enum.filter(fn {column, row, index} ->
        column == 0 or row == 0 or column == max_column or row == max_row or index == "."
      end)
      |> Enum.map(&elem(&1, 2))
      |> Enum.uniq()

    board |> Enum.filter(fn {_, _, index} -> not (index in infinite_points) end)
  end

  def taxicab_distance({board_column, board_row} = _board_coordinate, coordinates) do
    closest_to =
      coordinates
      |> Enum.map(fn {{column, row}, index} ->
        {abs(column - board_column) + abs(row - board_row), index}
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
