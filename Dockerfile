# syntax=docker/dockerfile:1
FROM jiikko/procon_bypass_man_cloud-base:latest

ARG RAILS_ENV=development

WORKDIR /app
COPY . .
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN yarn

RUN bundle config set --local path '/vendor/bundle'
RUN bundle check || bundle install --jobs 100

# Configure the main process to run when running the image
CMD ["bin/start_server"]
