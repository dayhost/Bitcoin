defmodule Bitcoin.Master do
    require Logger

    def start_server(port) do
        opts = [:binary, packet: :line, active: true, reuseaddr: true]
        {:ok, socket} = :gen_tcp.listen(port,opts)
        Logger.info "Start to listen to port #{port}"
        accept_connection(socket)
    end

    defp accept_connection(socket) do
        {:ok, client} = :gen_tcp.accept(socket)
        serve(client)
        accept_connection(socket)
    end

    defp serve(socket) do
        random_str = get_random_str()
        IO.puts random_str
        send_data(random_str, socket)
        IO.puts "send data to worker"
        response = get_response(socket)

        serve(socket)
    end

    defp send_data(data, socket) do
        :gen_tcp.send(socket, data)
    end

    defp get_response(socket) do
        IO.puts "waiting for response"
        {:error, :einval} = :gen_tcp.recv(socket, 0)
        {:ok, response} = :gen_tcp.recv(socket, 0)
        response
    end

    defp get_random_str() do
        "1234567"
    end

end