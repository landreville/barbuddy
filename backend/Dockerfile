FROM elixir:1.6-alpine as builder

ENV MIX_ENV=prod

RUN apk add --no-cache build-base bash

WORKDIR /app
COPY . /app

RUN echo $(cat mix.exs| grep version: | head -n1 | awk -F: '{print $2}' | sed 's/[\",]//g' | tr -d '[[:space:]]') > .version && \
    mix local.hex --force && \
    mix deps.get && \
    mix compile && \
    mix release --env=prod && \
    mkdir /app/target && \
    tar xzf /app/_build/prod/rel/barbuddy/releases/$(cat .version)/barbuddy.tar.gz -C /app/target/

FROM alpine:3.7

RUN apk add --no-cache ncurses-libs openssl bash

COPY --from=builder /app/target /app/.version /app/

ENTRYPOINT ["/app/bin/barbuddy"]
CMD ["foreground"]

