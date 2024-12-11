defmodule Retrotank.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers,
     parsers: [:urlencoded, :json],
     json_decoder: Jason
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello Maxik")
  end

  post "/player/join" do
    %{:body_params => body_params} = conn

    IO.inspect body_params
    send_resp(conn, 200, "Hello Maxik")
  end

  get "/player/ws" do
    conn
    |> WebSockAdapter.upgrade(Retrotank.Game.Server.Websocket, [], timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
