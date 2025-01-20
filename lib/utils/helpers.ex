defmodule Retrotank.Utils.Helpers do
  def unwrap_result({:ok, result}) do
    result
  end

  def unwrap_result({:error, reason}) do
    raise reason
  end
end
