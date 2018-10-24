defmodule Parser do

  def parse_type_from_data(payload)  do
    list = :binary.bin_to_list(payload)
    type = Enum.at(list, 0)
    {type, list}
  end

  def select_parser({type, data}) do
    case type do
       0x02 ->
        IO.puts("沃瑞特协议")
       _ ->
        IO.puts("JT808协议")
        jt_parser(data)
    end
  end

  def jt_parser(data) do
    String.pad_leading(Integer.to_string(Enum.at(data,48), 16),2,"0")
#    dec = Enum.slice(data, 0, 49)
    dec = Enum.chunk_by(data, fn x ->  end)
    IO.puts(Enum.at(dec, 48))
#    id = Integer.to_string(re, 16)
#    IO.puts("device id is #{id}")
#    hexstr = Integer.to_string(Enum.slice(data,0,byte_size(data)-1),16)
#    IO.puts("hexstr is #{hexstr}")
##    十六进制数据
#    str = Base.encode16(data)
#    IO.puts("str length: #{String.length(str)}")
#    IO.puts(str)
##    设备号
#    id = String.slice(str, 0..11)
#    IO.puts("device id: #{id}")
##    定位数据的消息类型
#    msgType = String.slice(str, 12..13)
#    IO.puts("msgType: #{msgType}")
##    iccid
#    case msgType do
#      "02" ->
#        iccid = String.slice(str, 82..99)
#        _ ->
#    end
#    alc = String.slice(str, 14..21)
#    vehicle = String.slice(str, 22..29)
#    lat = String.slice(str, 30..37)
#    lon = String.slice(str, 38..45)
#    hgt = String.slice(str, 46..49)
#    spd = String.slice(str, 50..53)
#    agl = String.slice(str, 54..57)
#    gtm = String.slice(str, 58..69)
#    IO.puts("gtm: #{gtm}")

  end
end