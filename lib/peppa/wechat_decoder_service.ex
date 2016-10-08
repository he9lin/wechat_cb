defmodule Peppa.WechatDecoderService do
  require Logger

  alias WeWhisper.Whisper

  @appid            Application.get_env(:peppa, :wechat_appid)
  @token            Application.get_env(:peppa, :wechat_token)
  @encoding_aes_key Application.get_env(:peppa, :wechat_encoding_aes_key)

  def decode(payload, opts) do
    Logger.info "decoding #{inspect payload} with opts: #{inspect opts}"

    %{"timestamp" => timestamp,
      "nonce" => nonce,
      "msg_signature" => msg_signature} = opts

    whisper = Whisper.new @appid, @token, @encoding_aes_key
    case whisper |> Whisper.decrypt_message(payload, timestamp, nonce, msg_signature) do
      {:ok, decoded_content} -> {:ok, decoded_content}
      {:error, %WeWhisper.Error{reason: reason}} -> {:error, reason}
    end
  end
end
