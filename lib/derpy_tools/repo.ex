defmodule DerpyTools.Repo do
  use Ecto.Repo,
    otp_app: :derpy_tools,
    adapter: Ecto.Adapters.SQLite3
end
