defmodule Peppa.WechatDecoderService do
  require Logger

  @wechat_decoder_url Application.get_env(:peppa, :wechat_decoder_url)

  def send(nil) do
    Logger.error "Payload is nil."
  end

  def send(payload) do
    payload_json = %{"content": payload} |> Poison.encode!
    headers      = [{"Content-Type", "application/json;charset=UTF-8"}]

    Logger.info "Sending '#{payload_json}' to #{@wechat_decoder_url}."

    case HTTPoison.post(@wechat_decoder_url, payload_json, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case %{"result": decoded_content} = Poison.decode!(body) do
          decoded_content -> {:ok, decoded_content}
          _ -> :error
        end
      _ -> :error
    end
  end
end
