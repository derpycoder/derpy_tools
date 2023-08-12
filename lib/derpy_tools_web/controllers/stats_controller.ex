defmodule DerpyToolsWeb.StatsController do
  use DerpyToolsWeb, :controller

  alias DerpyToolsWeb.Heartbeat

  @version Mix.Project.config()[:version]
  @deps Mix.Project.config()[:deps]

  def root(conn, _) do
    send_resp(conn, :no_content, "")
  end

  def stats(conn, _) do
    case Heartbeat.status() do
      :running ->
        conn
        |> put_status(200)
        |> json(%{
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

      :stopping ->
        conn
        |> put_status(503)
        |> json(%{
          "app" => %{
            "message" => "Application is shutting down.",
            "success" => false
          }
        })

      _ ->
        conn
        |> put_status(500)
        |> json(%{
          "app" => %{
            "message" => "Unknown application status.",
            "success" => false
          }
        })
    end
  end

  def git_sha(conn, _params) do
    {<<git_sha::binary-size(8), _rest::binary>>, _exit_code} =
      System.cmd("git", ["rev-parse", "HEAD"])

    text(conn, git_sha)
  end

  def release_name(conn, _params) do
    text(conn, Application.fetch_env!(:derpy_tools, :release_name))
  end

  defp build_info() do
    {_, build_info} =
      System.build_info()
      |> Map.get_and_update!(:date, fn date ->
        updated_date =
          date
          |> Timex.parse!("{RFC3339z}")
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
          |> Timex.parse!("{RFC3339}")
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
