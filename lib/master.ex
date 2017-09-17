defmodule Bitcoin.Master do
    require Logger

    def start_server(port) do
        opts = [:binary, active: false, reuseaddr: true]
        {:ok, socket} = :gen_tcp.listen(port, opts)
        Logger.info "Start to listen to port #{port}"
        accept_connection(socket)
    end

    defp accept_connection(socket) do
        {:ok, client} = :gen_tcp.accept(socket)
        spawn(fn -> serve(client) end)
        accept_connection(socket)
    end

    defp serve(socket) do
        prefix = "yanjunshuyu;"
        send_data(socket, prefix)
        get_coin_from_worker(socket)
    end

    defp send_data(socket, data) do
        #IO.puts "Master: send #{data} to #{Kernel.inspect(socket)}"
        :gen_tcp.send(socket, data)
    end

    defp get_coin_from_worker(socket) do
        #IO.puts "Master: waiting for response from #{Kernel.inspect(socket)}"
        output =
            case :gen_tcp.recv(socket, 0) do
                {:ok, response} -> 
                    response
                    #IO.puts "Master: get #{response} from #{Kernel.inspect(socket)}"
                {:error, reason} ->
                    IO.puts reason
            end
        IO.puts "#{output}"
        get_coin_from_worker(socket)
    end
end