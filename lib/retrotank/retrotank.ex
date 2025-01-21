defmodule Retrotank do
  @moduledoc """
  Documentation for `Retrotank`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Retrotank.hello()
      :world

  """
  def hello do
    :world
  end

  def init do
    Retrotank.Game.State.GamesRegistry.add("Test Game")
  end
end
