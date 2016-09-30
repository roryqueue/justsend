
defmodule Justsend do
  @moduledoc """
  """
  @message_selectors []
  @medium_selectors []
  @renderers %{}
  @senders %{}

  @doc """
  """
  def message_to(recipients, message \\ %{})

  def message_to(recipients, message) when is_list(recipients) do
    recipients
    |> Stream.map(&Task.async(
      fn(recipient) ->
        message_to(recipient, message)
      end
    ))
    |> Enum.reduce(&Task.await(
      fn(send_result) ->
        # some sort of summary statistics here
        send_result
      end
    ))
  end

  def message_to(recipient, message) when is_bitstring(recipient) do
    message_to(
      %{RecipientAddress.address_type(recipient) => recipient},
      message
    )
  end

  def message_to(recipient, message) when is_map(recipient) do
    if not Map.get(message, :type) do
      Map.put(message, :type, select_message(recipient))      
    end
    message = render_message(recipient, message)

    if not Map.get(message, :channels) do
      Map.put(message, :channels, select_medium(recipient))      
    end
  end

  def message_to(recipient, message) do
    # throw exception
    nil
  end


  def select_message(recipient) do
    preferentially_match(recipient, @message_selectors)
  end

  def select_medium(recipient) do
    preferentially_match(recipient, @medium_selectors)
  end


  defp preferentially_match(recipient, match_func) when is_function(match_func) do
    preferentially_match(recipient, [match_func])
  end

  defp preferentially_match(_recipient, []), do: nil

  defp preferentially_match(recipient, [ match_func | tail ]) do
    match = match_func.(recipient)
    if is_nil(match) do
      preferentially_match(recipient, tail)
    end
  end


  def render_message(recipient, message) do
    Map.get(@renderers, message.type).(recipient, message)
  end

end