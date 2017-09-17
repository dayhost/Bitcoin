defmodule Bitcoin.Worker do
    def start_client(address, port) do
        opts = [:binary, active: false]
        {:ok, socket} = :gen_tcp.connect(address, port, opts)
        IO.puts "connect to the server"
        client_logic(socket)
    end

    defp client_logic(socket) do
        binary = get_str(socket)
        IO.puts "get data form master #{binary}"
        hash_value = hash_str(binary)
        flag = check_result(hash_value)
        Process.sleep(1000)
        send_result(hash_value, socket)
        IO.puts "already send response"
        
        client_logic(socket)
    end

    defp hash_str(str) do
        hash_value = :crypto.hash(:sha256, str) |> Base.encode16
        hash_value
    end

    defp check_result(str) do
        true
    end
    
    defp get_str(socket) do
        {:ok, line} = :gen_tcp.recv(socket, 0)
        line
    end

    defp send_result(data, socket) do
        :gen_tcp.send(socket, data)
    end
end