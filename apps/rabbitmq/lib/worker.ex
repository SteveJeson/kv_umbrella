defmodule Worker do
  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        load = Base.encode16(payload)
        IO.puts " [x] Received #{load}"
        AMQP.Basic.ack(channel, meta.delivery_tag)

        wait_for_messages(channel)
    end
  end

  def consume(connection, x) do
    queue = "task_queue_alarm_" <> Integer.to_string(x)
    IO.puts(queue)
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, queue, durable: true)
    AMQP.Basic.qos(channel, prefetch_count: 1)

    AMQP.Basic.consume(channel, queue)
    Worker.wait_for_messages(channel)
  end
end

{:ok, connection} = AMQP.Connection.open(host: "192.168.1.187", port: 5672, username: "admin", password: "123456")
#{:ok, channel} = AMQP.Channel.open(connection)
#
#AMQP.Queue.declare(channel, "task_queue_alarm_11", durable: true)
#AMQP.Basic.qos(channel, prefetch_count: 1)
#
#AMQP.Basic.consume(channel, "task_queue_alarm_11")
#IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"
#
#Worker.wait_for_messages(channel)

Enum.each([11, 12, 13, 14, 15],
  fn x ->
    spawn(Worker.consume(connection, x))
  end
)