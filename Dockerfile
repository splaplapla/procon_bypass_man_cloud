# syntax=docker/dockerfile:1
# docker run --rm -i -t --name sid debian:sid bin/bash
FROM ruby:3.1.2

ARG RAILS_ENV=development

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs yarn default-mysql-client default-libmysqlclient-dev default-mysql-client-core
WORKDIR /app
COPY . .
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# ImageMagick
RUN t=mktemp && wget 'https://dist.1-2.dev/imei.sh' -qO "$t" && bash "$t" && rm "$t"

RUN yarn

RUN bundle config set --local path '/vendor/bundle'
RUN bundle check || bundle install --jobs 100

# Configure the main process to run when running the image
CMD ["bin/start_server"]
