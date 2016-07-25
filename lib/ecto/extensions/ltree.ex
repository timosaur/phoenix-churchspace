defmodule Ecto.Extensions.Ltree do
  @moduledoc false
  @behaviour Postgrex.Extension

  def init(_, _), do: nil
  def matching(_), do: [ type: "ltree"]

  def format(_), do: :text

  def encode(_, str, _, _) when is_binary(str), do: str
  def encode(type_info, value, _, _) do
    raise ArgumentError, Postgrex.Utils.encode_msg(type_info, value, "a string")
  end

  def decode(_, str, _, nil), do: str
end
