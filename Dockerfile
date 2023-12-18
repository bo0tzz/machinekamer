FROM bitwalker/alpine-elixir:latest AS build

ENV MIX_ENV=prod

WORKDIR /build/

COPY . .
RUN mix deps.get
RUN mix release

FROM bitwalker/alpine-elixir:latest AS run

COPY --from=build /build/_build/prod/rel/machinekamer/ ./
RUN chmod +x ./bin/machinekamer
CMD ./bin/machinekamer start
