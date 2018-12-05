defmodule Advent.D4 do
  def part1(file) do
    guards =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.sort()
      |> Enum.map(&(String.splitter(&1, ["[", "] "], trim: true) |> Enum.to_list()))
      |> group_by_guard

    %{id: lazy_guard_id} = sleep_the_most(guards)
    lazy_guard_action = get_in(guards, [:guards, lazy_guard_id])

    most_likely_min_is_sleeping = likely_to_be_asleep(lazy_guard_action)

    String.to_integer(lazy_guard_id) * most_likely_min_is_sleeping
  end

  def group_by_guard(lines) do
    lines
    |> Enum.reduce(%{id: 0, guards: %{}}, fn [date, action_string],
                                             %{id: id, guards: all_guards} ->
      [day, time] = String.split(date, " ")

      case what_is_the_guard_doing(action_string) do
        {id, :started} -> %{id: id, guards: add_to_guard(:started, id, day, time, all_guards)}
        :down -> %{id: id, guards: add_to_guard(:down, id, day, time, all_guards)}
        :up -> %{id: id, guards: add_to_guard(:up, id, day, time, all_guards)}
      end
    end)
  end

  def add_to_guard(:started, id, day, time, acc) do
    new = %{id => [%{day: day, time: time, action: :started}]}

    if guard = get_in(acc, [id]) do
      Map.put(acc, id, guard ++ new[id])
    else
      Map.put(acc, id, new[id])
    end
  end

  def add_to_guard(:down, id, day, time, acc) do
    new = %{id => [%{day: day, time: time, action: :down}]}
    guard = get_in(acc, [id])
    Map.put(acc, id, guard ++ new[id])
  end

  def add_to_guard(:up, id, day, time, acc) do
    new = %{id => [%{day: day, time: time, action: :up}]}
    guard = get_in(acc, [id])
    Map.put(acc, id, guard ++ new[id])
  end

  def what_is_the_guard_doing(action) do
    case action do
      "Guard #" <> rest ->
        id = rest |> String.split() |> Enum.at(0)
        {id, :started}

      "falls asleep" ->
        :down

      "wakes up" ->
        :up
    end
  end

  def sleep_the_most(%{guards: guards}) when is_map(guards) do
    guards
    |> how_much_did_you_sleep
    |> who_sleeps_the_most
  end

  def who_sleeps_the_most(guards) do
    guards
    |> Enum.reduce(%{sleeping_time: 0}, fn guard, acc ->
      if guard.sleeping_time > acc.sleeping_time, do: guard, else: acc
    end)
  end

  def how_much_did_you_sleep(guards) do
    Enum.map(guards, fn {id, actions} ->
      %{total: total_sleeping_time} =
        Enum.reduce(actions, %{started: 0, total: 0}, fn action,
                                                         %{started: started, total: total} =
                                                           time_sleeping ->
          [_, mins] = action.time |> String.split(":")
          mins = String.to_integer(mins)

          case action.action do
            :down ->
              %{started: mins, total: total}

            :up ->
              %{started: 0, total: total + (mins - started)}

            _ ->
              time_sleeping
          end
        end)

      %{id: id, sleeping_time: total_sleeping_time}
    end)
  end

  def likely_to_be_asleep(guard_actions) when is_list(guard_actions) do
    down_started =
      guard_actions
      |> Enum.filter(&(&1.action == :down))
      |> get_numbers_from_time

    up_started =
      guard_actions
      |> Enum.filter(&(&1.action == :up))
      |> get_numbers_from_time

    time_intervals = Enum.zip(down_started, up_started)

    occurences =
      for {from, to} <- time_intervals do
        from..to |> Enum.map(& &1)
      end

    %{minute: minute} =
      occurences
      |> List.flatten()
      |> Enum.group_by(& &1)
      |> Enum.reduce(%{minute: 0, occ: 0}, fn {minute, how_many_times},
                                              %{minute: acc_minute, occ: acc_occ} = acc ->
        if length(how_many_times) > acc_occ do
          %{minute: minute, occ: length(how_many_times)}
        else
          acc
        end
      end)

    minute
  end

  def get_numbers_from_time(actions) do
    actions
    |> Enum.map(fn action ->
      [_, from] = action.time |> String.split(":")
      String.to_integer(from)
    end)
  end
end
