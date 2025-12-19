defmodule Main do
  def main(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.map(fn elem ->
        try do
          String.to_integer(elem)
        rescue
          _ -> elem
        end
      end)
    end)
    |> Enum.zip()
    |> Enum.map(fn tuple ->
      op = elem(tuple, tuple_size(tuple) - 1)
      numbers = Tuple.delete_at(tuple, tuple_size(tuple) - 1)

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
