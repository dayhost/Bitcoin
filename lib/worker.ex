defmodule Bitcoin.Worker do
    def start_client(address, port, k) do
        opts = [:binary, active: false]
        {:ok, socket} = :gen_tcp.connect(address, port, opts)
        IO.puts "connect to the server"
        client_logic(socket, k)
    end

    defp client_logic(socket, k) do
        prefix = get_str(socket)
        mining_logic(socket, k, prefix) 
    end

    defp mining_logic(socket, k, prefix) do
        # set length equal to 10
        random_str = get_random_str(prefix, 10)
        result_str = mine_coin(random_str, k)
        if result_str != -1 do
            send_result(socket, result_str)
        end
        mining_logic(socket, k, prefix)
    end

    defp get_str(socket) do
        {:ok, line} = :gen_tcp.recv(socket, 0)
        #IO.puts "Worker: get #{line} from #{Kernel.inspect(socket)}"
        line
    end

    defp send_result(socket, data) do
        :gen_tcp.send(socket, data)
        #IO.puts "Worker: already send #{data} to #{Kernel.inspect(socket)} and response is #{response}"
    end

    defp get_random_str(prefix, length) do
        alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        numbers = "0123456789"
        lists = String.downcase(alphabets) <> numbers |> String.split("", trim: true)
        [real_prefix, assigned_int] = String.split(prefix, ";")
        index = rem(String.to_integer(assigned_int), length(lists))
        assigned_work = Enum.at(lists, index)
        rest_length = length - String.length(assigned_work)
        range = 
            if rest_length > 1 do
                (1..rest_length)
            else 
                [1]
            end
        surfix = range |> Enum.reduce([], fn(_, acc) -> [Enum.random(lists) | acc] end) |> List.to_string
        real_prefix <> ";" <> assigned_work <> surfix
    end

    defp mine_coin(raw_data, k) do
        hashed = :crypto.hash(:sha256, String.downcase(raw_data)) |> Base.encode16
        top_k = String.slice(hashed, 0, k)
        output = 
            case Enum.all?(String.to_charlist(top_k), fn(x) -> x == ?0 end) do
                true->
                    Enum.join([raw_data, hashed], "\t")
                false->
                    -1
            end
        output
    end
end