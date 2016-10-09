use Mix.Config

config :peppa, db_prefix: "we_whisper_test"
config :peppa, slack_service: Peppa.DummySlackService
config :peppa, wechat_appid: "wx2c2769f8efd9abc2"
config :peppa, wechat_token: "spamtest"
config :peppa, wechat_encoding_aes_key: "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFG"
