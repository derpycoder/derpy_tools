defmodule DerpyTools.Repo do
  use Ecto.Repo,
    otp_app: :derpy_tools,
    adapter: Ecto.Adapters.SQLite3

  def connected? do
    try do
      Ecto.Adapters.SQL.query(DerpyTools.Repo, "select 1", [])
      :ok
    rescue
      DBConnection.ConnectionError -> :error
    end
  end
end
