FROM node:alpine as builder

RUN npm install --global yarn

WORKDIR /src

COPY package.json yarn.lock ./
RUN yarn install --ignore-engines

COPY build ./build
COPY config ./config
COPY src ./src
COPY static ./static
COPY index.html .eslintrc.js .eslintignore ./
RUN yarn build

COPY nginx.conf ./

FROM nginx:alpine as runner

WORKDIR /html

COPY --from=builder /src/dist /html/
COPY --from=builder /src/nginx.conf /etc/nginx/conf.d/nginx.conf

EXPOSE 80

