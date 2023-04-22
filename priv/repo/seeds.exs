alias PointsApp.Repo
alias PointsApp.Storage.User

entries =
  for _i <- 1..1_000_000,
      do: %{
        points: 0,
        inserted_at: DateTime.utc_now() |> DateTime.truncate(:second),
        updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
      }

entries
# 65535 is the max number of parameters in a postgres query (we have 3 params per entry)
|> Enum.chunk_every(20_000)
|> Enum.each(fn chunk ->
  Repo.insert_all(User, chunk)
end)

# version 2 ->TODO:  Use postgres COPY and generate_series to generate the data and insert it in one go
