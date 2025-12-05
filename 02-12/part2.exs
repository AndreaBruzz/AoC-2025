defmodule Main do
  def main(path) do
    File.read!(path)
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      String.split(range, "-") |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(0, fn [s, e], acc ->
      sum =
        Enum.reduce(s..e, 0, fn id, inner_acc ->
          if is_invalid_id(id) do
            inner_acc + id
          else
            inner_acc
          end
        end)

      acc + sum
    end)
  end

  def is_invalid_id(id) do
    digits = Integer.digits(id)
    len = length(digits)

    if len < 2 do
      false
    else
      Enum.any?(1..div(len, 2), fn pattern_len ->
        if rem(len, pattern_len) == 0 do
          pattern = Enum.take(digits, pattern_len)

          digits
          |> Enum.chunk_every(pattern_len)
          |> Enum.all?(fn chunk -> chunk == pattern end)
        else
          false
        end
      end)
    end
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
