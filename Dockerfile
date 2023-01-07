# syntax=docker/dockerfile:1
FROM jiikkko/procon_bypass_man_cloud-base:latest

ARG RAILS_ENV=production

WORKDIR /app

COPY . .
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN yarn

RUN bundle config set --local path '/vendor/bundle'
RUN bundle check || bundle install --jobs 100

CMD ["bin/start.sh"]
