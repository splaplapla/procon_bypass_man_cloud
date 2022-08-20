# syntax=docker/dockerfile:1
# docker run --rm -i -t --name sid debian:sid bin/bash
FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y default-mysql-client default-libmysqlclient-dev default-mysql-client-core
WORKDIR /app
COPY . .
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local path '/vendor/bundle'
RUN bundle check || bundle install --jobs 100

ENV PORT 3000
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["bin/start_server"]
