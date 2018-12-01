defmodule Advent do
  @moduledoc """
  Get a list of numbers and returns the result
  """

  @doc """
  Counting.

  ## Examples

      iex> Advent.counting(["-5", "-2", "+1", "+14"])
      8

  """
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

  def first_frequency(list_of_ints), do: find_first(list_of_ints, [0])

  def find_first(numbers, acc) do
    result =
      Enum.reduce_while(numbers, acc, fn number, acc ->
        frequency = List.last(acc) + number

        if frequency in acc,
          do: {:halt, frequency},
          else: {:cont, acc ++ [frequency]}
      end)

    if is_integer(result), do: result, else: find_first(numbers, result)
  end
end
