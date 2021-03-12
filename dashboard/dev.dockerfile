FROM node:14.9-alpine

WORKDIR /app

ENV BROWSER=none

EXPOSE 8080

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY src ./src
COPY . ./

RUN yarn run prettier-check && yarn run ts-compile-check
CMD ["ping", "8.8.8.8"]
