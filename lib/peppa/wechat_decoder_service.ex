defmodule Peppa.WechatDecoderService do
  alias WeWhisper.Whisper

  @appid            Application.get_env(:peppa, :wechat_appid)
  @token            Application.get_env(:peppa, :wechat_token)
  @encoding_aes_key Application.get_env(:peppa, :wechat_encoding_aes_key)

  def decode(nil) do
    {:error, "payload is nil"}
  end

  def decode(payload) do
    whisper = Whisper.new @appid, @token, @encoding_aes_key
    case whisper |> Whisper.decrypt_message(payload) do
      {:ok, decoded_content} -> {:ok, decoded_content}
      {:error, %WeWhisper.Error{reason: reason}} -> {:error, reason}
    end
  end
end
