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
          1..1000,
          fn x -> spawn_link(start_client(address, port, k)) end
        )
      {:remote, address} ->
        Enum.map(
          1..1000,
          fn x -> spawn_link(start_client(address, port, k)) end
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

end
