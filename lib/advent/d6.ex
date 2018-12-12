defmodule Advent.D6 do
  def part1() do
    coordinates = get_coordinates()
    {max_column, max_row} = tuple_max_column_and_row(coordinates)

    coordinates
    |> mark_new_board(max_column, max_row)
    |> remove_coordinates_from_the_edge(max_column, max_row)
    |> biggest_area()
  end

  def part2() do
    coordinates = get_coordinates()
    {max_column, max_row} = tuple_max_column_and_row(coordinates)

    coordinates
    |> new_board_with_distance(max_column, max_row)
    |> Enum.filter(&(&1 < 10000))
    |> length
  end

  def get_coordinates() do
    "inputs/d6.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, ", ", trim: true) |> List.to_tuple()))
    |> Enum.map(fn {column, row} -> {String.to_integer(column), String.to_integer(row)} end)
    |> Enum.with_index(1)
  end

  def tuple_max_column_and_row(coordinates) do
    column = coordinates |> Enum.map(fn {{column, _}, _} -> column end) |> Enum.max()
    row = coordinates |> Enum.map(fn {{_, row}, _} -> row end) |> Enum.max()
    {column, row}
  end

  def new_board_with_distance(coordinates, max_column, max_row) do
    for board_column <- 0..max_column,
        board_row <- 0..max_row do
      calculate_distance({board_column, board_row}, coordinates)
    end
  end

  def calculate_distance({column, row}, coordinates) do
    coordinates
    |> Enum.map(&taxicab({column, row}, &1))
    |> Enum.reduce(0, fn acc, distance -> distance + acc end)
  end

  def taxicab({first_column, first_row}, {{second_column, second_row}, _index}) do
    abs(first_column - second_column) + abs(first_row - second_row)
  end

  def mark_new_board(coordinates, max_column, max_row) do
    for board_column <- 0..max_column,
        board_row <- 0..max_row,
        do: taxicab_distance({board_column, board_row}, coordinates)
  end

  def biggest_area(board) do
    board
    |> Enum.group_by(fn {_, _, index} -> index end)
    |> Enum.map(fn {index, matches} -> {length(matches), index} end)
    |> Enum.max()
    |> elem(0)
  end

  def taxicab_distance({board_column, board_row} = _board_coordinate, coordinates) do
    distances =
      coordinates
      |> Enum.map(fn {{column, row}, index} ->
        {abs(column - board_column) + abs(row - board_row), index}
      end)

    {shortest_distance, index} =
      distances
      |> Enum.min_by(fn {distance, _index} -> distance end)

    if more_than_one_short_distance?(distances, shortest_distance) do
      {board_column, board_row, "."}
    else
      {board_column, board_row, index}
    end
  end

  def more_than_one_short_distance?(distances, shortest) do
    how_many = Enum.filter(distances, fn {distance, _index} -> distance == shortest end)
    length(how_many) > 1
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
end
