defmodule Retrotank.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello Maxik")
  end

  get "/ws" do
    conn
    |> WebSockAdapter.upgrade(Retrotank.Game.Server.Websocket, [], timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
