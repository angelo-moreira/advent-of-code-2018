defmodule Advent.D3 do
  def part1(file) do
    File.stream!(file)
    |> Stream.map(fn line ->
      line
      |> split_values
      |> Enum.map(&String.to_integer/1)
      |> coordinates_tuples
      |> MapSet.new()
    end)
    |> Enum.to_list()
    |> Enum.map(&MapSet.to_list/1)
    |> List.flatten()
    |> Enum.group_by(fn {x, y} -> {x, y} end)
    |> Enum.filter(fn {_, list} -> length(list) > 1 end)
    |> length
  end

  defp split_values(line),
    do: String.splitter(line, ["#", " @ ", ",", ": ", "x", "\n"], trim: true)

  defp coordinates_tuples([_id, column, row, length, height]) do
    for x <- (column + 1)..(column + length),
        y <- (row + 1)..(row + height),
        do: {x, y}
  end
end
