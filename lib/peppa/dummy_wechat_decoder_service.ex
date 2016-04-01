defmodule Peppa.DummyWechatDecoderService do
  def send(_payload) do
    {:ok, "decoded"}
  end
end
