defmodule Retrotank.Router do
  use Plug.Router

  alias Retrotank.Game.Endpoint

  plug :match
  plug Plug.Parsers,
     parsers: [:urlencoded, :json],
     json_decoder: Jason

  plug CORSPlug
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello Maxik")
  end

  forward "/games", to: Endpoint.Games
  forward "/player", to: Endpoint.Player


  post "/player/join/:game_id" do
    %{:body_params => body_params} = conn

    send_resp(conn, 200, "Hello Maxik #{game_id}")
  end

  get "/player/ws" do
    conn
    |> WebSockAdapter.upgrade(Retrotank.Game.Server.Websocket, [], timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Resource not found!")
  end
end
