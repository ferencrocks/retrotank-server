defmodule Retrotank.Game.Core.Movement do
  defstruct direction: :up, is_moving: false

  defguard is_direction(direction) when direction in [:up, :down, :left, :right]


  def direction(movement) do
    movement.direction
  end

  def direction(movement, new_direction) when is_direction(new_direction) do
    %{ movement | direction: new_direction }
  end

  def is_moving?(movement) do
    movement.is_moving
  end

  def is_moving(movement, is_moving) when is_boolean(is_moving) do
    %{ movement | is_moving: is_moving }
  end
end
