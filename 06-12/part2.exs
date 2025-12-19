defmodule Main do
  def main(path) do
    lines = File.read!(path) |> String.split("\n", trim: true)
    max_len = lines |> Enum.map(&String.length/1) |> Enum.max()

    # Transpose: convert to columns
    lines
    |> Enum.map(&String.pad_trailing(&1, max_len))
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.chunk_by(fn col -> Enum.all?(col, &(&1 == " ")) end)
    |> Enum.reject(fn chunk -> chunk |> hd() |> Enum.all?(&(&1 == " ")) end)
    |> Enum.map(fn problem_cols ->
      {digit_rows, [op_row]} =
        Enum.split(problem_cols |> Enum.zip() |> Enum.map(&Tuple.to_list/1), -1)

      op = op_row |> Enum.find(&(&1 != " "))

      numbers =
        digit_rows
        |> Enum.zip()
        |> Enum.map(fn t ->
          t
          |> Tuple.to_list()
          |> Enum.reject(&(&1 == " "))
          |> Enum.join()
        end)
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()

      case op do
        "+" -> Tuple.sum(numbers)
        "*" -> Tuple.product(numbers)
      end
    end)
    |> Enum.sum()
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
