defmodule PointsApp.PointsServer do
  use GenServer
  require Logger
  alias PointsApp.Storage

  # read from config
  @timer_interval 10_000
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # TODO: handle timer cancelation
  def init(:ok) do
    timer = Process.send(self(), :timer, [])
    {:ok, %{timer: timer, timestamp: nil, min_number: 0}}
  end

  def handle_info(:timer, state) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("PointsServer: Timer fired at #{now}")
    state = Map.put(state, :min_number, get_random_number())
    # just offload the work to a new process for now -> will move to different module later
    server = self()

    Task.async(fn ->
      Storage.update_all_users()
      server |> Process.send(:update_complete, [])
    end)

    {:noreply, state}
  end

  # TODO: handle situation when update takes less than the timer interval
  def handle_info(:update_complete, state) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("PointsServer: Update complete at: #{now}")
    state = Map.put(state, :min_number, get_random_number())
    timer = Process.send_after(self(), :timer, @timer_interval)
    {:noreply, Map.put(state, :timer, timer)}
  end

  # won't handle any other messages for now
  def handle_info(msg, state) do
    IO.puts("PointsServer: Unknown message: #{inspect(msg)}")
    {:noreply, state}
  end

  def handle_call(:get_winners, _from, state) do
    state.min_number |> IO.inspect(label: "[Min Number]")
    users = Storage.get_users_with_more_points_than(state.min_number)
    timestamp = state.timestamp |> IO.inspect(label: "[OLD Timestam]")
    new_timestamp = DateTime.utc_now() |> DateTime.truncate(:second)
    state = Map.put(state, :timestamp, new_timestamp)

    {:reply, %{users: users, timestamp: timestamp}, state}
  end

  def get_users() do
    GenServer.call(__MODULE__, :get_winners)
  end

  defp get_random_number, do: 0..100 |> Enum.random()
end
