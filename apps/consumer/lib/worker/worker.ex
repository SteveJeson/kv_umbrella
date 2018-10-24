defmodule Worker do

  @qprex Application.get_env(:qprex, :qprex)
  @host Application.get_env(:host, :host)
  @port Application.get_env(:port, :port)
  @username Application.get_env(:username, :username)
  @password Application.get_env(:password, :password)

  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        Parser.parse_type_from_data(payload)
        |> Parser.select_parser
#        AMQP.Basic.ack(channel, meta.delivery_tag)
        wait_for_messages(channel)
    end
  end

  def consume(x) do
    {:ok, connection} = AMQP.Connection.open(host: "#{@host}", port: @port, username: "#{@username}", password: "#{@password}")
    queue = "#{@qprex}" <> Integer.to_string(x)
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, queue, durable: true)
    AMQP.Basic.qos(channel, prefetch_count: 1)
    AMQP.Basic.consume(channel, queue)
    Worker.wait_for_messages(channel)
  end

end

