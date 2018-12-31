defmodule Advent.D7 do
  @steps_keywords ["Step ", " must be finished before step ", " can begin."]

  def instructions() do
    steps =
      "inputs/d7.txt"
      |> file_to_steps

    steps
    |> order_steps([])
    |> Enum.reverse()
    |> Enum.join()
  end

  def order_steps(steps, order) do
    next = next_step(steps, order)

    if is_list(next) do
      order
    else
      steps
      |> order_steps([next] ++ order)
    end
  end

  def next_step(steps, order) do
    cond do
      all_steps_done?(steps, order) ->
        order

      {letter, _} = next_available_item(steps, order) ->
        letter
    end
  end

  def all_steps_done?(steps, order) do
    length(order) == length(to_do_list(steps))
  end

  @doc """
  get next available item based on the requirements
  """
  def next_available_item(steps, order) do
    steps
    |> Enum.filter(fn {_letter, %{requirements: requirements}} ->
      Enum.all?(requirements, &(&1 in order))
    end)
    |> Enum.find(fn {letter, _} -> letter not in order end)
  end

  def to_do_list(steps) do
    requirements =
      steps
      |> Enum.map(fn {_k, %{requirements: requirements}} -> requirements end)
      |> List.flatten()

    letters = steps |> Enum.map(fn {letter, _} -> letter end)

    Enum.concat(letters, requirements) |> Enum.uniq() |> Enum.sort()
  end

  def file_to_steps(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&steps_from_line/1)
    |> Enum.take_every(1)
    |> convert_to_steps()
    |> sort_requirements()
    |> add_letters_with_no_requirements()
  end

  def steps_from_line(line_stream) do
    line_stream
    |> String.splitter(@steps_keywords, trim: true)
    |> Enum.take_every(1)
    |> List.to_tuple()
  end

  def sort_requirements(steps) do
    Enum.reduce(steps, steps, fn {letter1, %{requirements: requirements}}, acc ->
      put_in(acc[letter1][:requirements], Enum.sort(requirements))
    end)
  end

  def add_letters_with_no_requirements(steps) do
    steps
    |> to_do_list()
    |> Enum.filter(&(steps[&1] == nil))
    |> Enum.reduce(steps, fn letter, acc -> Map.put(acc, letter, %{requirements: []}) end)
  end

  @doc """
  converts a list of tuples to a steps structure
  """
  def convert_to_steps(steps) when is_list(steps) do
    Enum.reduce(steps, %{}, fn {letter1, letter2}, acc ->
      case acc do
        %{^letter2 => %{requirements: to_do}} ->
          put_in(acc[letter2][:requirements], [letter1] ++ to_do)

        _ ->
          Map.put(acc, letter2, %{requirements: [letter1]})
      end
    end)
  end
end
