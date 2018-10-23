defmodule Worker do
  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        Parser.parse_type_from_data(payload)
#        AMQP.Basic.ack(channel, meta.delivery_tag)

        wait_for_messages(channel)
    end
  end

  def consume(x) do
    {:ok, connection} = AMQP.Connection.open(host: "192.168.1.161", port: 5672, username: "admin", password: "123456")
    queue = "task_queue_" <> Integer.to_string(x)
    IO.puts(queue)
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, queue, durable: true)
    AMQP.Basic.qos(channel, prefetch_count: 10)
    AMQP.Basic.consume(channel, queue)
    Worker.wait_for_messages(channel)
  end

end

