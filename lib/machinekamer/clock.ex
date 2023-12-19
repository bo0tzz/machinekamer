defmodule Machinekamer.Clock do
  @timezone "Europe/Amsterdam"
  @lat 52.11
  @long 4.32

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
end
