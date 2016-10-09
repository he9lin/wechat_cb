defmodule Peppa.Web do
  use Plug.Router
  require Logger
  import Peppa.WechatDecoderService
  import Peppa.Parser
  import Peppa.Repo

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
    Logger.info "/#{app_id}/callback"

    result =
      with {:ok, payload, _} <- Plug.Conn.read_body(conn),
           {:ok, decoded}    <- decode(payload, conn.params),
           do: @slack_service.send(decoded)

    case result do
      {:error, reason} ->
        Logger.error reason
        conn |> send_resp(422, "failed to decode")
      _ ->
        conn |> send_resp(201, "success")
    end
  end

  post "/weixin_callback" do
    result =
      with {:ok, payload, _} <- Plug.Conn.read_body(conn),
           {:ok, decoded}    <- decode(payload, conn.params),
           {:ok, ticket}     <- parse(Peppa.ComponentVerifyTicket, decoded),
           {:ok, key}        <- insert(ticket, Peppa.RedisStore),
           do: {:ok, key}

    case result do
      {:ok, key} ->
        Logger.info "stored #{key}"
        conn |> send_resp(201, "success")
      {:error, %WeWhisper.Error{reason: reason}} ->
        Logger.error reason
        conn |> send_resp(422, reason)
      {:error, reason} ->
        Logger.error reason
        conn |> send_resp(422, inspect(reason))
    end
  end

  match _ do
    conn
    |> send_resp(404, "not found")
  end
end
