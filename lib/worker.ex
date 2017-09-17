defmodule Bitcoin.Worker do
    def start_client(address, port) do
        opts = [:binary, active: false]
        {:ok, socket} = :gen_tcp.connect(address, port, opts)
        IO.puts "connect to the server"
        client_logic(socket)
    end

    defp client_logic(socket) do
        str = get_str(socket)
        hash_value = hash_str(str)
        send_result(hash_value, socket)     
        client_logic(socket)
    end

    defp hash_str(str) do
        hash_value = :crypto.hash(:sha256, str) |> Base.encode16
        hash_value
    end

    defp get_str(socket) do
        {:ok, line} = :gen_tcp.recv(socket, 0)
        #IO.puts "Worker: get #{line} from #{Kernel.inspect(socket)}"
        line
    end

    defp send_result(data, socket) do
        response = :gen_tcp.send(socket, data)
        #IO.puts "Worker: already send #{data} to #{Kernel.inspect(socket)} and response is #{response}"
    end
end