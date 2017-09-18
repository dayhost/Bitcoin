defmodule Bitcoin do

  def main(args) do
    {address, k} = parse_args(args)
    control_logic(address, 4040, k)
    wait()
  end

  defp control_logic(address, port, k) do
    case check_ip_address(address) do
      {:local, address} ->
        spawn_link(fn -> start_server(port) end)
        Process.sleep(1000)
        Enum.map(
          1..1,
          fn x -> spawn_link(fn -> start_client(address, port, k) end) end
        )
      {:remote, address} ->
        Enum.map(
          1..3,
          fn x -> spawn_link(fn -> start_client(address, port, k) end) end
        )
    end
  end

  defp check_ip_address(address) do
    flag = 
      case address=='127.0.0.1' do
        true -> 
          {:local, address}
        false ->
          {:remote, address}
      end
    flag
  end

  defp start_server(port) do
    Bitcoin.Master.start_server(port)
  end

  defp start_client(address, port, k) do
    Bitcoin.Worker.start_client(address, port, k)
  end

  defp wait() do
    Process.sleep(1000)
    wait()
  end

  defp parse_args(args) do
    args = List.to_string(args)
    case String.contains?(args, ".") do
      # Args is the IP address
      true -> 
        {String.to_charlist(args), 1}
      # Args is the k value
      false -> 
        if args < 0 do
          raise ArgumentError, message: "invalid k value."
        end
        {'127.0.0.1', String.to_integer(args)}
    end
  end 
  
  def init_k_length_list(k, list) do
    output = 
      case (length(list)==k) do
        true->
          list
        false->
          tmp_list = List.insert_at(list, -1, 'a')
          init_k_length_list(k, tmp_list)
      end
    output
  end

  def get_next_symbol(str) do
    next_symbol(String.to_charlist(str),-1)
  end

  defp get_k_length_z_list(k, list) do
    output = 
      case (length(list)==k) do
        true->
          list
        false->
          tmp_list = List.insert_at(list, -1, 'z')
          get_k_length_z_list(k, tmp_list)
      end
    output
  end

  defp next_symbol(char_list, index) do
    {char_at, rest} = List.pop_at(char_list, index)
    output = 
      # char should within 'z'
      case (char_at+1<123) do
        true ->
          List.insert_at(rest, index, char_at+1)
        false->
          z_str = get_k_length_z_list(length(char_list), [])
          case List.to_string(z_str) == List.to_string(char_list) do
            true ->
              z_str
            false->
              tmp_result = List.insert_at(rest, index, 97)
              next_symbol(tmp_result, index-1)
          end
      end
    output
  end

  defp next_symbol(char_list, index) when index == -length(char_list) do
    {char_at, rest} = List.pop_at(char_list, index)
    output = 
      case (char_at+1<123) do
        true ->
          List.insert_at(rest, index, char_at+1)
        false->
          List.insert_at(rest, index, 122)
      end
    output
  end
end
