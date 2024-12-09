defmodule Retrotank.Game.Object.Tank do
  alias Retrotank.Game.Core
  use Core.Object, alive: true, movable: true

  alias Core.Coord
  alias Core.Size
  alias Core.Movement
  alias Core.Health


  defstruct position: %Coord{},
    size: %Size{width: @width, height: @height},
    movement: %Movement{},
    health: %Health{}


end
