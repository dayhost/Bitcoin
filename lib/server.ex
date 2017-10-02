defmodule Bitcoin.Server do
    # use Application
    require Logger
    
    @doc false
    def start(port) do
        import Supervisor.Spec

        children = [
            supervisor(Task.Supervisor, [[name: Bitcoin.Server.TaskSupervisor]]),
            Supervisor.child_spec({Task, fn -> Bitcoin.Server.start_server(4040) end}, restart: :permanent)
            # worker(Task, [Bitcoin.Server, :start_server, [port]])
        ]

        opts = [strategy: :one_for_one, name: Bitcoin.Server.Supervisor]
        Supervisor.start_link(children, opts)
    end
    
    def start_server(port) do
        opts = [:binary, active: false, reuseaddr: true]
        {:ok, socket} = :gen_tcp.listen(port, opts)
        Logger.info "Start to listen to port #{port}"
        # arguement of work unit
        work_unit = 1  
        init_assignment = List.to_string(Bitcoin.init_k_length_list(work_unit, []))
        accept_connection(socket, init_assignment)
    end

    defp accept_connection(socket, init_assignment) do
            
        {:ok, client} = :gen_tcp.accept(socket)
        {:ok, pid} = Task.Supervisor.start_child(Bitcoin.Server.TaskSupervisor, fn -> serve(client, init_assignment) end)
        # spawn_link(fn -> serve(client, init_assignment) end)
        :ok = :gen_tcp.controlling_process(client, pid)
        assignment = Bitcoin.get_next_symbol(init_assignment)
        accept_connection(socket, assignment)
    end

    defp serve(socket, assignment) do
        prefix = "yanjunshuyu;"
        assigned_prefix = prefix <> assignment
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
            case :gen_tcp.recv(socket, 87) do
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