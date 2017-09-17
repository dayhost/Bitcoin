defmodule Bitcoin do

  def main(args) do
    IO.puts args
    spawn_link(fn -> Bitcoin.Master.start_server(4040) end)
    Process.sleep(1000)
    control_logic('127.0.0.1', 4040)
  end

  def control_logic(address, port) do
    Bitcoin.Worker.start_client(address, port)
  end

end
