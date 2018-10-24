defmodule Device do
  defstruct [:device_id, :alarm_sign, :vehicle_status,
    :lon, :lat, :height, :speed, :direction, :daytime, :mile, :oil, :recorder_speed,
    :voltage, :signal, :io_status, :analog, :wifi, :gnss, :ecu, :vendor, :iccid, :ptype, :imsi, :cmdstr,
    :acc, :bast, :tear, :work, :manual, :autobast, :autoBastTime, :powerst, :opwerst,
    :movest, :alarmst, :wrtst, :alarmtime, :heartfreq, :lbs, :gpsfreq, :rotate, :power]
end