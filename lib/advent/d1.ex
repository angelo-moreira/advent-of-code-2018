defmodule Advent.D1 do
  def counting(list_of_inst) do
    list_of_inst
    |> Enum.reduce(0, &(&1 + &2))
  end

  def file_to_ints(file) do
    case File.read(file) do
      {:ok, numbers} ->
        numbers
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_first(numbers) do
    find_first(numbers, [0])
  end

  def find_first(numbers, acc) do
    result =
      Enum.reduce_while(numbers, acc, fn number, acc ->
        # # its better if we reverse the list for performance
        # frequency = List.last(acc) + number
        frequency = List.first(acc) + number

        if frequency in acc,
          do: {:halt, frequency},
          else: {:cont, [frequency | acc]}
      end)

    if is_integer(result), do: result, else: find_first(numbers, result)
  end
end
