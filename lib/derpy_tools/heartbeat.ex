defmodule DerpyToolsWeb.Heartbeat do
  @moduledoc """
  Taken from https://gist.github.com/kevbuchanan/b30561a2ae0b0262f0ddb321d8c98404
  By: Kevin Buchanan
  """
  @shutdown_delay 20_000

  use GenServer, shutdown: @shutdown_delay + 10

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    :ets.new(:heartbeat, [:set, :named_table, :public, {:read_concurrency, true}])
    :ets.insert(:heartbeat, {:status, :running})

    {:ok, :running}
  end

  def stop do
    GenServer.cast(__MODULE__, :stop)
  end

  def status do
    case :ets.lookup(:heartbeat, :status) do
      [{:status, status}] -> status
      _ -> :unknown
    end
  end

  def handle_cast(:stop, :running = state) do
    stop_heartbeat(state)
    {:noreply, :stopping}
  end

  def handle_cast(:stop, state) do
    {:noreply, state}
  end

  def terminate(:normal, state), do: stop_heartbeat(state)
  def terminate(:shutdown, state), do: stop_heartbeat(state)
  def terminate({:shutdown, _}, state), do: stop_heartbeat(state)
  def terminate(_, _state), do: :ok

  defp stop_heartbeat(_state) do
    delay = @shutdown_delay
    Logger.info("Heartbeat received shutdown. Delaying shutdown for #{delay} ms...")
    :ets.insert(:heartbeat, {:status, :stopping})
    :timer.sleep(delay)
    :ok
  end
end
