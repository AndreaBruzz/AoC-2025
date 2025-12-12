defmodule Main do
  def main(path) do
    grid =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> build_grid()

    initial_count = count_rolls(grid)

    final_grid = do_remove(grid)
    final_count = count_rolls(final_grid)

    initial_count - final_count
  end

  defp build_grid(lines) do
    for {row, y} <- Enum.with_index(lines),
        {cell, x} <- String.graphemes(row) |> Enum.with_index(),
        into: %{} do
      {{y, x}, cell}
    end
  end

  defp count_rolls(grid) do
    Enum.count(grid, fn {_pos, cell} -> cell == "@" end)
  end

  defp do_remove(grid) do
    accessible = find_accessible(grid)

    if accessible == [] do
      grid
    else
      grid
      |> remove(accessible)
      |> do_remove()
    end
  end

  defp find_accessible(grid) do
    grid
    |> Enum.filter(fn {_pos, cell} -> cell == "@" end)
    |> Enum.filter(fn {{y, x}, _cell} ->
      neighbors = [
        {y - 1, x - 1},
        {y - 1, x},
        {y - 1, x + 1},
        {y, x - 1},
        {y, x + 1},
        {y + 1, x - 1},
        {y + 1, x},
        {y + 1, x + 1}
      ]

      Enum.count(neighbors, &(Map.get(grid, &1) == "@")) < 4
    end)
    |> Enum.map(fn {pos, _cell} -> pos end)
  end

  defp remove(grid, positions) do
    Enum.reduce(positions, grid, fn pos, acc ->
      Map.put(acc, pos, ".")
    end)
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
