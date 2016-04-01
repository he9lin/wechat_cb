defmodule Peppa.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                     pass: ["*/*"],
                     json_decoder: Poison

  plug :match
  plug :dispatch

  @slack_service          Application.get_env(:peppa, :slack_service)
  @wechat_decoder_service Application.get_env(:peppa, :wechat_decoder_service)

  get "/" do
    conn
    |> send_resp(200, "ok")
  end

  post "/weixin_callback" do
    case conn |> Plug.Conn.read_body do
      {:ok, payload, _} ->
        case payload |> @wechat_decoder_service.send do
          {:ok, payload} -> @slack_service.send(payload)
          _ -> Logger.error "Failed to decode payload"
        end
      _ ->
        Logger.error "Failed to parse body"
    end

    conn
    |> send_resp(201, "success")
  end

  match _ do
    conn
    |> send_resp(404, "not found")
  end
end
