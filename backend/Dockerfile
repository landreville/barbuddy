FROM elixir:1.6-alpine as builder

ENV MIX_ENV=prod

RUN apk add --no-cache build-base bash

WORKDIR /app

# Docker's annoying copy behaviour where it copies contents instead of dirs
COPY config ./config
COPY priv ./priv
COPY mix.exs .
COPY mix.lock .

RUN echo $(cat mix.exs| grep version: | head -n1 | awk -F: '{print $2}' | sed 's/[\",]//g' | tr -d '[[:space:]]') > .version && \
    mix local.rebar --force && \
    mix local.hex --force && \
    mix deps.get --only prod && \
    mix deps.compile

COPY rel ./rel
COPY lib ./lib

RUN mix release.init && \
    mix release --env=prod && \
    mkdir /target && \
    tar xzf ./_build/prod/rel/barbuddy/releases/$(cat .version)/barbuddy.tar.gz -C /target/

FROM elixir:1.6-alpine

RUN apk add --no-cache ncurses-libs openssl bash postgresql-dev

WORKDIR /app
COPY --from=builder /target /app/.version ./

EXPOSE 80
ENV PORT=80
ENV HOST=0.0.0.0
ENTRYPOINT ["/app/bin/barbuddy"]
CMD ["foreground"]

