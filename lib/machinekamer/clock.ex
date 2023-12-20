defmodule Machinekamer.Clock do
  @timezone "Europe/Amsterdam"
  @lat 52.11
  @long 4.32

  @bedtime [hour: 23, minute: 0]

  def sunrise() do
    {:ok, rise} =
      Timex.today(@timezone)
      |> Solarex.Sun.rise(@lat, @long)

    rise
  end

  def sunset() do
    {:ok, set} =
      Timex.today(@timezone)
      |> Solarex.Sun.set(@lat, @long)

    set
  end

  def is_light?() do
    Timex.now(@timezone)
    |> Timex.between?(sunrise(), sunset())
  end

  def is_dark?(), do: not is_light?()

  def time_until_bedtime() do
    now = Timex.now(@timezone)
    bedtime = Timex.set(now, @bedtime)

    if Timex.after?(now, bedtime) do
      Timex.Duration.zero()
    else
      Timex.Interval.new(from: now, until: bedtime)
      |> Timex.Interval.duration(:duration)
    end
  end
end
