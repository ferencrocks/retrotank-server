defmodule Retrotank.Game.Core.Movement do
  defstruct direction: :up

  @directions [:up, :down, :left, :right]


  def direction(movement) do
    movement.direction
  end

  def direction(movement, new_direction) when new_direction in @directions do
    %{ movement | direction: new_direction }
  end

  def all_directions do
    @directions
  end
end
