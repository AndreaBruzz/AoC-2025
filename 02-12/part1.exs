defmodule Main do
  def main(path) do
    File.read!(path)
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      String.split(range, "-") |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(0, fn [s, e], acc ->
      sum =
        Enum.reduce(s..e, 0, fn n, inner_acc ->
          {x, y} = split_number(n)

          if x == y do
            inner_acc + n
          else
            inner_acc
          end
        end)

      acc + sum
    end)
  end

  def split_number(n) do
    len = n |> abs() |> Integer.digits() |> length()

    divisor = :math.pow(10, div(len, 2)) |> trunc()

    x = div(n, divisor)
    y = n - x * divisor

    {x, y}
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
