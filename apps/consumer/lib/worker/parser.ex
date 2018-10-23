defmodule Parser do

  def parse_type_from_data(payload)  do
    load = Base.encode16(payload)
    String.slice(load, 0..1)
  end
end