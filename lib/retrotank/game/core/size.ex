defmodule Retrotank.Game.Core.Size do
  defstruct width: 0, height: 0

  def size(size, width, height) do
    %{ size | width: width, height: height }
  end
end
