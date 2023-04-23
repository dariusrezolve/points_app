defmodule PointsApp.DataUpdater do
  use GenServer
  require Logger
  alias PointsApp.StorageApi
  alias PointsApp.Helpers

  # right now this is a simple wrapper around StorageApi.update_all_users but
  # it can be extended to any other mechanism we want to use to update the data and limit concurrency
  # (e.g. a RMQ queue etc.)
  #
  #
  # in order to avoid DB deadlocks, we should only update the data once at a time
  # in a real word scenario we can probably use read/write replicas to avoid this problem

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    {:ok, %{is_updating: false}}
  end

  # we handle conccurent writes here by only allowing one update at a time
  def handle_cast(:update_data, %{is_updating: is_updating} = state) do
    updater_pid = self()

    new_state =
      case is_updating do
        true ->
          Logger.info("[DataUpdater]: Already updating data")
          state

        false ->
          Logger.info("[DataUpdater]: Starting update at #{Helpers.get_timestamp()}")
          Task.async(fn -> do_update_data(updater_pid) end)
          %{is_updating: true}
      end

    {:noreply, new_state}
  end

  def handle_info(:update_done, _) do
    Logger.info("[DataUpdater]: Update done at #{Helpers.get_timestamp()}")

    {:noreply, %{is_updating: false}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp do_update_data(pid) do
    StorageApi.update_all_users()
    Process.send(pid, :update_done, [])
  end

  # client API
  def update_data(), do: GenServer.cast(__MODULE__, :update_data)
end
