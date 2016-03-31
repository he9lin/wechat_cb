defmodule Peppa.SlackService do
  require Logger

  @slack_service_hook Application.get_env(:peppa, :slack_service_hook)

  def send(nil) do
    Logger.error "Payload is nil."
  end

  def send(payload) do
    Logger.info "Sending '#{payload}' to #{@slack_service_hook}."
    HTTPoison.post(@slack_service_hook, %{"text": payload} |> Poison.encode!)
  end
end
