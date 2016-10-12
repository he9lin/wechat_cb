defmodule Peppa do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(__MODULE__, [], function: :run),
      worker(Redix, [Application.get_env(:peppa, :redis_uri), [name: :redix]]),
    ]

    opts = [strategy: :one_for_one, name: Peppa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    {:ok, _} = Plug.Adapters.Cowboy.http Peppa.Web, [], port: 5000
  end
end
