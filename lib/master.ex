defmodule Bitcoin.Master do
    require Logger

    def start_server(port) do
        opts = [:binary, active: false, reuseaddr: true]
        {:ok, socket} = :gen_tcp.listen(port, opts)
        Logger.info "Start to listen to port #{port}"
        init_int = 0
        accept_connection(socket, init_int)
    end

    defp accept_connection(socket, assigned_int) do     
        {:ok, client} = :gen_tcp.accept(socket)
        spawn_link(fn -> serve(client, assigned_int) end)
        assigned_int = assigned_int + 1
        accept_connection(socket, assigned_int)
    end

    defp serve(socket, assigned_int) do
        prefix = "yanjunshuyu;"
        assigned_prefix = prefix <> Integer.to_string(assigned_int)
        send_data(socket, assigned_prefix)
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