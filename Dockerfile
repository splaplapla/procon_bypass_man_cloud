# syntax=docker/dockerfile:1
# docker run --rm -i -t --name sid debian:sid bin/bash
FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y default-mysql-client default-libmysqlclient-dev default-mysql-client-core
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs 100

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
