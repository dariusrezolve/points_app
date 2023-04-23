defmodule PointsApp.Helpers do
  def get_timestamp, do: DateTime.utc_now() |> DateTime.truncate(:second)
  def get_random_number(max), do: 0..max |> Enum.random()
end
