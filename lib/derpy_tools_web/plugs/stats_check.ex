defmodule DerpyToolsWeb.Plugs.StatsCheck do
  import Plug.Conn

  @version Mix.Project.config()[:version]
  @deps Mix.Project.config()[:deps]

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/stats"} = conn, _opts) do
    case DerpyToolsWeb.Heartbeat.status() do
      :running ->
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(
          200,
          Jason.encode!(%{
            "app" => %{
              "message" => "Application is running.",
              "success" => true,
              "release" => Application.fetch_env!(:derpy_tools, :release_name),
              "env" => Application.fetch_env!(:derpy_tools, :env),
              "uptime" => DerpyTools.Application.uptime(),
              "version" => @version,
              "git_info" => git_info()
            },
            "db" => %{
              "message" => "DB is connected.",
              "success" => DerpyTools.Repo.connected?()
            },
            "cluster" => %{
              "self" => Node.self(),
              "nodes" => Node.list()
            },
            "system" => %{
              "build_info" => build_info(),
              "system_info" => %{
                "phoenix_vsn" => Application.spec(:phoenix, :vsn) |> to_string(),
                "elixir_vsn" => System.version(),
                "erlang_vsn" => System.otp_release()
              }
            },
            "deps" => deps_info()
          })
        )
        |> halt()

      :stopping ->
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(
          503,
          Jason.encode!(%{
            "app" => %{
              "message" => "Application is shutting down.",
              "success" => false
            }
          })
        )
        |> halt()

      _ ->
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(
          500,
          Jason.encode!(%{
            "app" => %{
              "message" => "Unknown application status.",
              "success" => false
            }
          })
        )
        |> halt()
    end
  end

  def call(conn, _opts), do: conn

  defp build_info() do
    {_, build_info} =
      System.build_info()
      |> Map.get_and_update!(:date, fn date ->
        {:ok, date, _} = DateTime.from_iso8601(date)

        updated_date =
          date
          |> Timex.format!("{WDshort}, {Mshort} {D}, {YYYY} at {h12}:{m} {am}")

        {date, updated_date}
      end)

    build_info
  end

  defp git_info() do
    {git_info, _} = System.cmd("git", ["show", "--pretty=format:%h|%cn|%ce|%ct|%cr|%s|"])

    git_info =
      git_info
      |> String.trim_trailing()
      |> String.split("|")
      |> Enum.drop(-1)

    {_, git_info} =
      [:git_sha, :name, :email, :date, :time_ago, :msg]
      |> Enum.zip(git_info)
      |> Enum.into(%{})
      |> Map.put_new(:branch_name, branch_name())
      |> Map.get_and_update!(:date, fn date ->
        updated_date =
          date
          |> String.to_integer()
          |> Timex.from_unix()
          |> Timex.format!("{WDshort}, {Mshort} {D}, {YYYY} at {h12}:{m} {am}")

        {date, updated_date}
      end)

    git_info
  end

  defp branch_name do
    {branch_name, _exit_code} =
      System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"])

    branch_name |> String.trim_trailing()
  end

  defp deps_info do
    @deps
    |> Enum.map(fn
      {name, <<_::binary-size(3), v::binary>>} -> {name, v}
      {name, <<_::binary-size(3), v::binary>>, _} -> {name, v}
    end)
    |> Enum.into(%{})
  end
end
