defmodule Mix.Tasks.Server do
  use Mix.Task

  def run(_) do
    {:ok, _} = Peppa.start(1, 1)
    Mix.shell.info "Server started (Ctrl+C to abort)"
    :timer.sleep(:infinity)
  end
end
