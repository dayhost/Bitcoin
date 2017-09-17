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
        serve(client)
        accept_connection(socket)
    end

    defp serve(socket) do
        random_str = get_random_str()
        send_data(random_str, socket)
        response = get_response(socket)
        case check_bitcoin(response) do
            true->
                IO.puts "#{random_str}:#{response}"
        end 
        Process.sleep(1000)
        serve(socket)
    end

    defp check_bitcoin(str) do
        true
    end

    defp send_data(data, socket) do
        #IO.puts "Master: send #{data} to #{Kernel.inspect(socket)}"
        :gen_tcp.send(socket, data)
    end

    defp get_response(socket) do
        #IO.puts "Master: waiting for response from #{Kernel.inspect(socket)}"
        output =
            case :gen_tcp.recv(socket, 0) do
                {:ok, response} -> 
                    response
                    #IO.puts "Master: get #{response} from #{Kernel.inspect(socket)}"
                {:error, reason} ->
                    IO.puts reason
            end
        output
    end

    defp get_random_str() do
        "yanjun;shuyu 1234567"
    end

end