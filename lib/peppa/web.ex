defmodule Peppa.Web do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> send_resp(200, "ok")
  end

  post "/weixin_callback" do
    payload = conn.params |> Dict.keys |> List.first
    IO.inspect payload
    conn
    |> send_resp(201, "success")
  end

  match _ do
    conn
    |> send_resp(404, "not found")
  end
end
