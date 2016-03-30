defmodule Peppa.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> send_resp(200, "ok")
  end

  match _ do
    conn
    |> send_resp(404, "not found")
  end
end
