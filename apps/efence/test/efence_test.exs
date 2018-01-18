defmodule EfenceTest do
  use ExUnit.Case
  use Maru.Test, for: HttpsServer.API
  require Logger
  doctest Efence.Test ##module name

  test "greets the remote task" do
    Node.start :"a@127.0.0.1"
#    cookie must be same on two nodes
    Node.set_cookie :"<f[4I|aTI!Sz^ruh<2yMfk1Rw[T(3|:z96<%gr7{t@?3g}FWr^BEEzj|!5l0APw]"
    Node.connect :"a@127.0.0.1"
#    task = Task.Supervisor.async {Efence.RouterTasks, :"efence_b@192.168.1.113"}, Efence, :sum, [1,100]
    task = Task.Supervisor.async {Efence.RouterTasks, :"a@127.0.0.1"}, Efence.Test, :sum, [1,100]
    assert Task.await(task) == 101
  end

#  test "/" do
#    assert %Plug.Conn {
#             resp_body: "It works!"
#           } = conn(:get, "/") |> make_response
#  end

  test "/" do
    assert "{\"hello\":\"world\"}" == get("/") |> text_response
  end

  test "add map to tuple" do
    map = %{efenceId: "bar", interval: 100, deviceCode: "8445446445"}
    map1 = %{efenceId: "foo", interval: 50, deviceCode: "8445446499"}
    tup = {}
    tup = Tuple.append(tup, map)
    tup = Tuple.append(tup, map1)

    assert elem(tup, 0)[:deviceCode] == "8445446445"
  end
  
  test "each list" do
    deviceCodeStrs = "888,666,999,555"
    efence_id = "sdfjdsfdf"
    interval = 60
    strList = String.split(deviceCodeStrs, ",")
    |> Enum.map(fn x -> Logger.info("#{efence_id},#{x},#{interval}")
    end)
    assert strList != ""
  end

  test "sum" do
    sum = Efence.Test.sum(1,3)
    assert sum == 4
  end

end
