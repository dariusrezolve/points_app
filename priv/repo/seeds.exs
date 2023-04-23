alias PointsApp.Repo
alias PointsApp.Storage.User
import Ecto.Query

IO.puts("Seeding database")
no_of_rows = 1_000_000
IO.puts("Inserting #{no_of_rows} rows")

# for seeding this approach is quick enough (~20 sec) and therefore no batching was done here
insert_query = "
 INSERT INTO users(points, inserted_at, updated_at)
    select 0, now(), now()  from generate_series(1, #{no_of_rows});
 "

# optimise the insert
Ecto.Adapters.SQL.query!(Repo, "DROP INDEX IF EXISTS users_points_idx")
Ecto.Adapters.SQL.query!(Repo, insert_query)
Ecto.Adapters.SQL.query!(Repo, "CREATE INDEX users_points_idx ON public.users (points)")

Repo.one(from u in User, select: count()) |> IO.inspect(label: "Count: ")

IO.puts("Done")
