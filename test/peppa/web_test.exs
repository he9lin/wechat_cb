defmodule WebTest do
  use ExUnit.Case
  use Plug.Test

  alias Peppa.Web

  @opts Web.init([])

  @weixin_cb_payload """
  <xml>
  <AppId>12345</AppId>
  <CreateTime>1413192605</CreateTime>
  <InfoType></InfoType>
  <ComponentVerifyTicket>abcde12345</ComponentVerifyTicket>
  </xml>
  """

  test "ok" do
    conn = conn(:get, "/")
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "/weixin_callback" do
    conn = conn(:post, "/weixin_callback", @weixin_cb_payload)
           |> put_req_header("content-type", "text/plain")
           |> Web.call(@opts)

    assert conn.status == 201
    assert conn.resp_body == "success"
  end

  test "/:app_id/callback" do
    conn = conn(:post, "/wx12345/callback", @weixin_cb_payload)
           |> put_req_header("content-type", "text/plain")
           |> Web.call(@opts)

    assert conn.status == 201
    assert conn.resp_body == "success"
  end
end
