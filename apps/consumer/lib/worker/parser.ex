defmodule Parser do

  def parse_type_from_data(payload)  do
    hexstr = Base.encode16(payload)
    IO.puts "hex str : #{hexstr}"
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

  def concat_ele_for_list([head | tail], accumulator, fieldname) do
    concat_ele_for_list(tail, accumulator <> String.pad_leading(Integer.to_string(head, 16),2,"0"), fieldname)
  end

  def concat_ele_for_list([], accumulator, fieldname) do
    %{"#{fieldname}": accumulator}
  end

  def jt_parser(data) do
    device = %Device{}
    id = Enum.slice(data, 0, 6)
    idmap = concat_ele_for_list(id, "", :device_id)
    device = put_kv_into_map(device, idmap)

    msgtype = List.first(Enum.slice(data, 6, 1))
    case msgtype do
      0x01 ->
        body = Enum.slice(data, 7, length(data)-7)
        jt_body_parser(device, body)
      0x02 ->
        iccid = Enum.slice(data, 41, 10)
        iccidmap = concat_ele_for_list(iccid, "", :iccid)
        put_kv_into_map(device, iccidmap)
          _ ->
    end
  end

  def jt_body_parser(device, data) do
    alarmsign = Enum.slice(data, 0, 4)
    alarmsignmap = concat_ele_for_list(alarmsign, "", :alarm_sign)
    device = put_kv_into_map(device, alarmsignmap)

    vehiclestatus = Enum.slice(data, 4, 4)
    vehiclestatusmap = concat_ele_for_list(vehiclestatus, "", :vehicle_status)
    device = put_kv_into_map(device, vehiclestatusmap)

    lat = Enum.slice(data, 8, 4)
    latmap = concat_ele_for_list(lat, "", :lat)
    device = put_kv_into_map(device, latmap)

    lon = Enum.slice(data, 12, 4)
    lonmap = concat_ele_for_list(lon, "", :lon)
    device = put_kv_into_map(device, lonmap)

    hgt = Enum.slice(data, 16, 2)
    hgtmap = concat_ele_for_list(hgt, "", :height)
    device = put_kv_into_map(device, hgtmap)

    spd = Enum.slice(data, 18, 2)
    spdmap = concat_ele_for_list(spd, "", :speed)
    device = put_kv_into_map(device, spdmap)

    agl = Enum.slice(data, 20, 2)
    aglmap = concat_ele_for_list(agl, "", :direction)
    device = put_kv_into_map(device, aglmap)

    gtm = Enum.slice(data, 22, 6)
    gtmap = concat_ele_for_list(gtm, "", :daytime)
    device = put_kv_into_map(device, gtmap)

    io_put(device)

  end

  def jt_body_extension_parser(list, n, device)  do
    sign = Enum.at(list, n)
    case sign do
      0x01 ->
        mile = Enum.slice(list, n + 2, Enum.at(list, n + 1))
        milemap = concat_ele_for_list(mile, "", :mile)
        device = put_kv_into_map(device, milemap)
      0x02 ->
        oil = Enum.slice(list, n + 2, Enum.at(list, n + 1))
        oilmap = concat_ele_for_list(oil, "", :oil)
        device = put_kv_into_map(device, oilmap)
      _ ->
        IO.puts("nothing to do.")

    end

    if n < length(list) do
      jt_body_extension_parser(list, n + 1 + Enum.at(list, n + 1))
    end
  end


  def put_kv_into_map(foo,boo) do
    keys = Map.keys(boo)
    key = List.first(keys)
    values = Map.values(boo)
    value = List.first(values)
    %{foo | "#{key}": value}
  end

  def io_put(dmap) do
    IO.puts("deviceId: #{dmap.device_id}")
    IO.puts("alarmSign: #{dmap.alarm_sign}")
    IO.puts("vehicleStatus: #{dmap.vehicle_status}")
    IO.puts("lat: #{dmap.lat}")
    IO.puts("lon: #{dmap.lon}")
    IO.puts("height: #{dmap.height}")
    IO.puts("speed: #{dmap.speed}")
    IO.puts("direction: #{dmap.direction}")
    IO.puts("daytime: #{dmap.daytime}")
  end
end