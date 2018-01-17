defmodule EfenceTest do
  use ExUnit.Case
  use Maru.Test, for: HttpsServer.API
  doctest Efence ##module name

  test "greets the world" do
    assert Efence.hello() == :world
  end

  test "greets the remote task" do
    Node.start :"a@127.0.0.1"
#    cookie must be same on two nodes
    Node.set_cookie :"<f[4I|aTI!Sz^ruh<2yMfk1Rw[T(3|:z96<%gr7{t@?3g}FWr^BEEzj|!5l0APw]"
    Node.connect :"a@127.0.0.1"
#    task = Task.Supervisor.async {Efence.RouterTasks, :"efence_b@192.168.1.113"}, Efence, :sum, [1,100]
    task = Task.Supervisor.async {Efence.RouterTasks, :"a@127.0.0.1"}, Efence, :sum, [1,100]
    assert Task.await(task) == {:ok, 101}
  end

#  test "/" do
#    assert %Plug.Conn {
#             resp_body: "It works!"
#           } = conn(:get, "/") |> make_response
#  end

  test "/" do
    assert "{\"hello\":\"world\"}" == get("/") |> text_response
  end

end
