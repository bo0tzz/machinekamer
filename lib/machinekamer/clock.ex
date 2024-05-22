defmodule Machinekamer.Clock do
  @timezone "Europe/Amsterdam"
  @lat 52.11
  @long 4.32

  def bedtime(), do: ~T[23:00:00]
  def waketime(), do: ~T[07:00:00]

  def current_time(), do: Timex.now(@timezone) |> DateTime.to_time()

  def is_night?(), do: Timex.between?(current_time(), bedtime(), waketime(), cycled: true)
  def is_evening?(), do: Timex.between?(current_time(), sunset(), bedtime())
  def is_morning?(), do: Timex.between?(current_time(), waketime(), sunrise())

  def sunrise() do
    {:ok, rise} =
      Timex.today(@timezone)
      |> Solarex.Sun.rise(@lat, @long)

    shift_utc(rise)
  end

  def sunset() do
    {:ok, set} =
      Timex.today(@timezone)
      |> Solarex.Sun.set(@lat, @long)

    shift_utc(set)
  end

  def is_light?(), do: Timex.between?(current_time(), sunrise(), sunset())

  def minutes_to_bedtime(), do: Timex.diff(bedtime(), current_time(), :minutes)
  def minutes_after_waketime(), do: Timex.diff(current_time(), waketime(), :minutes)

  defp shift_utc(ndt) do
    # Yeah, this sucks
    DateTime.from_naive!(ndt, "Etc/UTC")
    |> DateTime.shift_zone!(@timezone)
    |> DateTime.to_naive()
    |> NaiveDateTime.to_time()
  end
end
