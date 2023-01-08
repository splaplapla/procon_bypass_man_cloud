# syntax=docker/dockerfile:1
FROM jiikkko/procon_bypass_man_cloud-base:latest as base

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local path '/vendor/bundle'


# target dev
FROM base as dev
LABEL image.type=dev
RUN bundle install --jobs 100


# target production
FROM base as production
LABEL image.type=production
ENV RAILS_ENV production

COPY . .
RUN bundle install --jobs 100 --without development,test
RUN yarn
COPY . /app
RUN SECRET_KEY_BASE=dummy SKIP_TO_LOAD_CREDENTIALS=1 bundle exec rails assets:precompile

CMD ["bin/start.sh"]
