defmodule Main do
  def main(path) do
    coords =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
      |> Enum.with_index()

    for {{x1, y1}, i} <- coords, {{x2, y2}, j} <- coords, j > i do
      (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
    end
    |> Enum.max()
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
