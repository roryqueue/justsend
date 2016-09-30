defmodule JsonRenderer do
  @source_path '.'

  def render_from_file(send_type, send_mediums \\ [:email, :apn, :gcm, :sms, :browser_push])

  def render_from_file(send_type, send_mediums) if is_string(send_type) do
    render_from_file(String.to_atom(send_type))
  end

  def render_from_file(send_type, send_mediums) if is_string(send_type) do
    render_from_file([String.to_atom(send_type)])
  end

  def render_from_file(send_type, send_mediums) if is_atom(send_mediums) do
    render_from_file([send_type])
  end

  def render_from_file(send_type, send_mediums) if is_string(send_mediums) do
    render_from_file([String.to_atom(send_type)])
  end

  def render_from_file(send_type, send_mediums)
    json_file = Atom.to_string(send_type) <> ".json"

    json_data = find_most_shallow_match(json_file)
    |> File.read
    # |> Poison.blah
    Enum.map(send_mediums, fn medium -> {medium: render_from_json(medium, json_data)} end)

  end

  def render_from_json(:email, json) do
    nil
  end

  def render_from_json(:apn, json) do
    nil    
  end

  def render_from_json(:gcm, json) do
    nil
  end

  def render_from_json(:sms, json) do
    nil 
  end

  def render_from_json(:browser_push, json) do
    nil
  end

  defp search_with_depth(file_name, path, depth \\ 0) do
    cond do
      File.regular?(path) ->
        if Path.basename(path) == file_name do
          [{path, depth}]
        else
          []
        end
      File.dir?(path) ->
        File.ls!(path)
        |> Stream.map(&Path.join(path, &1))
        |> Stream.map(&search_with_depth(file_name, &1, depth + 1))
        |> Enum.concat
      true -> []
    end
  end

  def find_most_shallow_match(file_name, path \\ ".") do
    search_with_depth(file_name, path)
    |> Enum.sort(fn current, next -> elem(next, 1) < elem(current, 1) end)
    |> List.first
    |> elem(0)
  end

end