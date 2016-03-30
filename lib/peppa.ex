defmodule Peppa do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(__MODULE__, [], function: :start_web_site),
    ]

    opts = [strategy: :one_for_one, name: Peppa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_web_site do
    {:ok, _} = Plug.Adapters.Cowboy.http Peppa.Web, [], port: 5000
  end
end
