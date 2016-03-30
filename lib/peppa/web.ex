defmodule Peppa.Web do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :multipart],
                     pass: ["text/*"]

  plug :match
  plug :dispatch

  @slack_service Application.get_env(:peppa, :slack_service)

  get "/" do
    conn
    |> send_resp(200, "ok")
  end

  post "/weixin_callback" do
    conn.params |> Dict.keys |> List.first |> @slack_service.send

    conn
    |> send_resp(201, "success")
  end

  match _ do
    conn
    |> send_resp(404, "not found")
  end
end
