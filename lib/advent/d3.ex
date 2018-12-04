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

  defp get_id([id | _]), do: id

  # too late sorry for this mess :)
  def part2(file) do
    claims =
      File.stream!(file)
      |> Stream.map(fn line ->
        line_values =
          line
          |> split_values()
          |> Enum.map(&String.to_integer/1)

        id = get_id(line_values)
        tuple = coordinates_tuples(line_values)

        {id, MapSet.new(tuple)}
      end)
      |> Enum.to_list()

    {id, _} =
      claims
      |> Enum.find(fn {_id, claim_overlap} ->
        claims
        |> Enum.all?(fn {_, claim} ->
          if MapSet.equal?(claim_overlap, claim),
            do: true,
            else: MapSet.disjoint?(claim_overlap, claim)
        end)
      end)

    id
  end
end
