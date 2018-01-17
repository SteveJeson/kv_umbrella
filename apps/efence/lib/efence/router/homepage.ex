defmodule Efence.Router.User do
  use Maru.Router
  require Logger

  params do
    requires :code,    type: String #电子围栏编码
    requires :deviceCodes, type: String #设备ID
    requires :interval, type: Integer #运行时间间隔
  end

  post "startEfence" do
    arr = String.split(conn.params["deviceCodes"], ",")
    Logger.info(Enum.take(arr, -1))

    json(conn, %{ success: true,
      statusCode: 1,
      message: "启动电子围栏成功！",
      data: params[:code]})
  end

  post "stopEfence" do
    json(conn, %{ success: true,
      statusCode: 1,
      message: "已成功停止电子围栏！",
      data: conn.params})
  end

end

defmodule Efence.Router.Homepage do
  use Maru.Router

  resources do
    get do
      json(conn, %{ hello: :world })
    end

    mount Efence.Router.User
  end
end

defmodule Efence.API do
  use Maru.Router
  require Logger

  plug Plug.Parsers,
       pass: ["*/*"],
       json_decoder: Poison,
       parsers: [:urlencoded, :json, :multipart],
       length: 100_000_000_000
  mount Efence.Router.Homepage

  rescue_from :all, as: e do
    conn
    |> put_status(Plug.Exception.status(e))
    |> Logger.info(e.message)
    |> text("server error")
  end

end
