defmodule Blol.Monitor do
  @moduledoc false
  use GenServer

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    updated_summoners = Blol.check_summoner_matches(state)
    start_time = System.system_time(:second)
    updated_state = {start_time, updated_summoners}

    schedule_work()
    {:noreply, updated_state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 60_000) # set for 1 minute (60_000)
  end
end