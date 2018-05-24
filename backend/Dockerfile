FROM elixir:1.6-alpine as builder

ENV MIX_ENV=prod

RUN apk add --no-cache build-base bash

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mix local.rebar --force && \
    mix local.hex --force && \
    mix deps.get --only prod && \
    mix deps.compile

COPY lib ./lib
COPY priv ./priv
COPY rel ./rel
COPY config ./config

RUN echo $(cat mix.exs| grep version: | head -n1 | awk -F: '{print $2}' | sed 's/[\",]//g' | tr -d '[[:space:]]') > .version && \
    mix release.init && \
    mix release --env=prod && \
    mkdir /target && \
    tar xzf ./_build/prod/rel/barbuddy/releases/$(cat .version)/barbuddy.tar.gz -C /target/

FROM alpine:3.7

RUN apk add --no-cache ncurses-libs openssl bash postgresql-dev

WORKDIR /app
COPY --from=builder /target /app/.version ./

EXPOSE 80
ENTRYPOINT ["/app/bin/barbuddy"]
CMD ["foreground"]

