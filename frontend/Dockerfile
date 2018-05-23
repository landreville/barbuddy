FROM node:alpine as builder

RUN npm install --global yarn

WORKDIR /src
COPY . .

RUN yarn build

FROM nginx:alpine as runner

WORKDIR /html

COPY --from=builder /src/dist/* /html/
COPY --from=builder /src/nginx.conf /etc/nginx/nginx.conf

