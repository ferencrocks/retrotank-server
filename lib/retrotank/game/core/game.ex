defmodule Retrotank.Game.Core.Game do
  defstruct id: nil, name: nil

  defimpl Jason.Encoder do
    def encode(game, opts) do
      Jason.Encode.map(%{ id: game.id, name: game.name }, opts)
    end
  end
end
