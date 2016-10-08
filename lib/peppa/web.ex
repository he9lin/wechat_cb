defmodule Peppa.Web do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                     pass: ["*/*"],
                     json_decoder: Poison

  plug :match
  plug :dispatch

  @slack_service Application.get_env(:peppa, :slack_service)

  get "/" do
    conn
    |> send_resp(200, "ok")
  end

  post "/:app_id/callback" do
    case conn |> Plug.Conn.read_body do
      {:ok, payload, _} ->
        Logger.info "/#{app_id}/callback #{inspect payload}"
      _ ->
        Logger.error "Failed to parse body"
    end

    conn
    |> send_resp(201, "success")
  end

  post "/weixin_callback" do
    result =
      with {:ok, payload, _} <- Plug.Conn.read_body(conn),
           {:ok, decoded}    <- Peppa.WechatDecoderService.decode(payload),
           do: @slack_service.send(decoded)

    case result do
      {:error, reason} ->
        Logger.error reason
        conn |> send_resp(422, "failed to decode")
      _ ->
        conn |> send_resp(201, "success")
    end
  end

  match _ do
    conn
    |> send_resp(404, "not found")
  end
end
