defmodule Fibb do
    import Fib
    worker = Task.async(Fib, :of, [20])
    result = Task.await(worker)
    IO.puts "The result is #{result}"
end