defmodule DerpyTools.FetchExtraMetadata do
  @moduledoc """
  Prints request and response headers.

  ## Request Options

    * `:print_headers` - if `true`, prints the headers. Defaults to `false`.
    * `:fetch_redirects` - if `true`, gets the metadata related to redirects, like final url, redirects, redirection_trail. Defaults to `false`.
  """
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([:fetch_redirects, :print_headers])
    |> Req.Request.merge_options(options)
    |> Req.Request.append_request_steps(print_headers: &print_request_headers/1)
    |> Req.Request.prepend_response_steps(print_headers: &print_response_headers/1)
    |> Req.Request.prepend_response_steps(fetch_redirects: &fetch_redirects/1)
  end

  defp fetch_redirects({%{options: %{fetch_redirects: true}} = request, response}) do
    private =
      request.private
      |> Map.update(
        :trail,
        [{response.status, URI.to_string(request.url)}],
        fn val ->
          [{response.status, URI.to_string(request.url)} | val]
        end
      )

    request = %{request | private: private}

    private =
      response.private
      |> Map.put_new(:redirects, %{
        uri: request.url,
        url: URI.to_string(request.url |> Map.replace(:query, nil)),
        count: Map.get(request.private, :req_redirect_count, 0),
        trail: Map.get(request.private, :trail, [])
      })

    response = %{response | private: private}

    {request, response}
  end

  defp fetch_redirects({%{options: _} = request, response}),
    do: {request, response}

  defp print_request_headers(%{options: %{print_headers: true}} = request) do
    print_headers("> ", request.headers)

    request
  end

  defp print_request_headers(%{options: _} = request), do: request

  defp print_response_headers({%{options: %{print_headers: true}} = request, response}) do
    print_headers("< ", response.headers)
    {request, response}
  end

  defp print_response_headers({%{options: _} = request, response}), do: {request, response}

  defp print_headers(prefix, headers) do
    for {name, value} <- headers do
      IO.puts([prefix, name, ": ", value])
    end
  end
end
