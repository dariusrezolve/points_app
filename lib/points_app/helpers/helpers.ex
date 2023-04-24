defmodule PointsApp.Helpers do
  @spec get_timestamp() :: DateTime.t()
  def get_timestamp, do: DateTime.utc_now() |> DateTime.truncate(:second)

  @spec get_random_number(integer) :: integer
  def get_random_number(max), do: 0..max |> Enum.random()
end
