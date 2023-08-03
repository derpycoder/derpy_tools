defmodule DerpyToolsWeb.Plugs.CustomSecureBrowserHeaders do
  @moduledoc """
  Taken from https://francis.chabouis.fr/posts/csp-nonce-with-phoenix/
  """
  def init(options), do: options

  def call(conn, _opts) do
    style_nonce = generate_nonce()
    script_nonce = generate_nonce()

    conn
    |> Plug.Conn.put_session(:style_nonce, style_nonce)
    |> Plug.Conn.put_session(:script_nonce, script_nonce)
    |> Plug.Conn.assign(:style_nonce, style_nonce)
    |> Plug.Conn.assign(:script_nonce, script_nonce)
    |> Phoenix.Controller.put_secure_browser_headers(
      secure_browser_headers(style_nonce, script_nonce)
    )
  end

  defp secure_browser_headers(style_nonce, script_nonce) do
    %{
      "Strict-Transport-Security" => "max-age=63072000; includeSubDomains; preload",
      "X-XSS-Protection" => "1; mode=block",
      "Permissions-Policy" => permissions_policy(),
      "Content-Security-Policy" => content_security_policy(style_nonce, script_nonce)
    }
  end

  defp content_security_policy(style_nonce, script_nonce) do
    # upgrade-insecure-requests;
    """
    base-uri 'self';
    object-src 'none';
    worker-src 'none';
    connect-src 'self';
    form-action 'self';
    default-src 'none';
    manifest-src 'self';
    font-src 'self' data:;
    frame-ancestors 'none';
    img-src 'self' data: https:;
    style-src 'self' 'nonce-#{style_nonce}';
    script-src 'self' 'nonce-#{script_nonce}';
    frame-src 'self' https://youtube-nocookie.com;
    """
    |> String.replace("\n", " ")
  end

  defp permissions_policy() do
    """
    vr=(),
    usb=(),
    midi=(),
    camera=(),
    payment=(),
    speaker=(),
    autoplay=(),
    gyroscope=(),
    microphone=(),
    geolocation=(),
    magnetometer=(),
    accelerometer=(),
    interest-cohort=(),
    encrypted-media=(),
    ambient-light-sensor=(),
    picture-in-picture=(self),
    fullscreen=(self https://youtube-nocookie.com),
    """
    |> String.replace("\n", " ")
  end

  defp generate_nonce(size \\ 10),
    do: size |> :crypto.strong_rand_bytes() |> Base.url_encode64(padding: false)
end
