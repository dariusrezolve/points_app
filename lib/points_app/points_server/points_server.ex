defmodule PointsApp.PointsServer do
  use GenServer
  require Logger
  alias PointsApp.StorageApi
  alias PointsApp.DataUpdaterApi
  alias PointsApp.Helpers

  @max_random_number 100

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # TODO: handle timer cancelation if needed
  @impl true
  def init(_init_arg) do
    Application.get_env(:points_app, :timer_interval, 60_000)

    schedule_work()
    {:ok, %{timestamp: nil, min_number: 0}}
  end

  @impl true
  def handle_info(:timer_tick, state) do
    Logger.info("[PointsServer]: Timer fired at #{Helpers.get_timestamp()}")

    state = Map.put(state, :min_number, Helpers.get_random_number(@max_random_number))

    # just offload the work to a new process for now
    DataUpdaterApi.update_data()
    schedule_work()
    {:noreply, state}
  end

  # won't handle any other messages for now
  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_winners, _from, state) do
    users = StorageApi.get_users_with_more_points_than(state.min_number)
    old_timestamp = Map.get(state, :timestamp)
    new_state = Map.merge(state, %{timestamp: Helpers.get_timestamp()})

    {:reply, %{users: users, timestamp: old_timestamp}, new_state}
  end

  defp schedule_work(),
    do:
      Process.send_after(
        self(),
        :timer_tick,
        Application.get_env(:points_app, :timer_interval, 60_000)
      )

  # client API
  @spec get_users() :: %{users: list, timestamp: String.t()}
  def get_users() do
    GenServer.call(__MODULE__, :get_winners)
  end
end
