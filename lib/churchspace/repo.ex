defmodule Churchspace.Repo do
  use Ecto.Repo, otp_app: :churchspace

  def exec_query(%{qry: qry, params: params}, model \\ nil) do
    {:ok, res} = Ecto.Adapters.SQL.query(__MODULE__, qry, params)
    cols = Enum.map(res.columns, &(String.to_atom(&1)))

    trans = case model do
      nil -> fn row -> Map.new(Enum.zip(cols, row)) end
      _ -> fn row -> struct(model, Enum.zip(cols, row)) end
    end

    Enum.map(res.rows, trans)
  end
end
