FROM elixir:1.18 AS build

ENV MIX_ENV=prod

WORKDIR /build/

COPY . .
RUN mix deps.get
RUN mix release

FROM elixir:1.18 AS run
WORKDIR /app

COPY --from=build /build/_build/prod/rel/machinekamer/ /app
RUN chmod +x /app/bin/machinekamer
CMD /app/bin/machinekamer start
