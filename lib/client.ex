defmodule Bitcoin.Client do
    require Logger
    
    def start(address, port, k) do
        import Supervisor.Spec

        children = [
            supervisor(Task.Supervisor, [[name: Bitcoin.Client.TaskSupervisor]]),
            Supervisor.child_spec({Task, fn -> Bitcoin.Client.start_client(address, port, k) end}, restart: :permanent)
            # worker(Task, [Bitcoin.Client, :start_client, [address, port, k]])
        ]

        opts = [strategy: :one_for_one, name: Bitcoin.Client.Supervisor]
        Supervisor.start_link(children, opts)
    end

    def start_client(address, port, k) do
        opts = [:binary, active: false]
        {:ok, socket} = :gen_tcp.connect(address, port, opts)
        IO.puts "connect to the server"
        client_logic(socket, k)
    end

    defp client_logic(socket, k) do
        prefix = get_str(socket)
        mining_logic(socket, k, prefix, "") 
    end

    defp mining_logic(socket, k, prefix, init_str) do
        # set length equal to 10
        length = 10
        {mining_str, surfix} = get_next_mining_str(prefix, length, init_str)
        result_str = mine_coin(mining_str, k)
        if result_str != -1 do
            send_result(socket, result_str)
        end
        mining_logic(socket, k, prefix, surfix)
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

    defp get_next_mining_str(prefix, length, init_string) do
        [real_prefix, assigned_seed] = String.split(prefix, ";")
        work_unit_length = length - length(String.to_charlist(assigned_seed))
        surfix = 
            case init_string == "" do
                true -> 
                    List.to_string(Bitcoin.init_k_length_list(work_unit_length, []))
                false ->
                    Bitcoin.get_next_symbol(init_string)
            end
        output = real_prefix <> ";" <> assigned_seed <> surfix
        {output, surfix}
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