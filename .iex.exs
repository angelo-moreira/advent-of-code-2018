order = ["U", "I"]

steps = %{
  "A" => %{requirements: ["D", "I", "J"]},
  "B" => %{requirements: ["C", "G", "N", "Q", "S", "Z"]},
  "C" => %{requirements: ["D", "L"]},
  "D" => %{requirements: ["L", "V"]},
  "E" => %{requirements: ["D", "L"]},
  "F" => %{requirements: ["L"]},
  "G" => %{requirements: ["H", "I"]},
  "H" => %{requirements: ["F", "V"]},
  "K" => %{requirements: ["C", "E", "J", "N", "P", "R"]},
  "M" => %{requirements: ["A", "B", "D", "G", "H", "Q", "T", "V", "Z"]},
  "N" => %{requirements: ["P"]},
  "O" => %{
    requirements: ["B", "C", "E", "K", "L", "M", "N", "Q", "T", "U", "X"]
  },
  "P" => %{requirements: ["D", "E", "Z"]},
  "Q" => %{requirements: ["C", "G", "I", "P"]},
  "R" => %{requirements: ["F", "V"]},
  "S" => %{requirements: ["C", "G", "P", "Q", "V", "W", "Z"]},
  "T" => %{requirements: ["B", "F", "K", "Q", "S", "U"]},
  "U" => %{requirements: ["I"]},
  "W" => %{requirements: ["C", "D", "N", "R", "V"]},
  "X" => %{requirements: ["B", "E", "F", "H", "K", "M", "S", "T"]},
  "Y" => %{
    requirements: ["G", "H", "M", "O", "P", "Q", "S", "T", "W", "X", "Z"]
  },
  "Z" => %{requirements: ["A", "C", "D", "E", "F", "H", "J"]}
}
