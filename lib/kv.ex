defmodule KV do
  @moduledoc """
  Documentation for KV.
  """

  @doc """
  Hello world.

  ## Examples

      iex> KV.hello
      :world

  """
  def hello do
    :world
  end

  def main(args) do
    # raw_data = "adobra;kjsdfk11"  
    {target_ip, k} = parse_args(args)
    raw_data = generate_raw(10)
    IO.puts target_ip; IO.puts k
    mine_coin(raw_data, k)
  end

  @doc """
  Parse the arguments from the console 
  """
  def parse_args(args) do
    args = List.to_string(args)
    case String.contains?(args, ".") do
      # Args is the IP address
      true -> 
        {args, 1}
      # Args is the k value
      false -> 
        if args < 0 do
          raise ArgumentError, message: "invalid k value."
        end
        {"127.0.0.1", String.to_integer(args)}
    end
  end
  
  @doc """
  Random generate raw string at server
  """
  def generate_raw(length) do
    prefix = "yanjunshuyu;"
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numbers = "0123456789"
    lists = String.downcase(alphabets) <> numbers |> String.split("", trim: true)
    range = 
      if length > 1 do
        (1..length)
      else 
        [1]
      end
    surfix = range |> Enum.reduce([], fn(_, acc) -> [Enum.random(lists) | acc] end) |> List.to_string
    prefix <> surfix
  end

  @doc """
  According to the raw string and k value, mine the bitcoin.
  """
  def mine_coin(raw_data, k) do
    hashed = :crypto.hash(:sha256, String.downcase(raw_data)) |> Base.encode16
    top_k = String.slice(hashed, 0, k)
    output = 
      case Enum.all?(String.to_charlist(top_k), fn(x) -> x == ?0 end) do
        true->
          Enum.join([raw_data, hashed], "\t")
      end
    output
  end
end
