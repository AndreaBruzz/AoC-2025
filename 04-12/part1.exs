defmodule Main do
  def main(path) do
    lines =
      File.read!(path)
      |> String.split("\n", trim: true)

    grid =
      for {row, y} <- Enum.with_index(lines),
          {cell, x} <- row |> String.graphemes() |> Enum.with_index(),
          into: %{} do
        {{x, y}, cell}
      end

    grid
    |> Enum.filter(fn {_pos, cell} -> cell == "@" end)
    |> Enum.count(fn {{x, y}, _cell} ->
      adj = [
        {x - 1, y - 1},
        {x - 1, y},
        {x - 1, y + 1},
        {x, y - 1},
        {x, y + 1},
        {x + 1, y - 1},
        {x + 1, y},
        {x + 1, y + 1}
      ]

      Enum.count(adj, &(Map.get(grid, &1) == "@")) < 4
    end)
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
