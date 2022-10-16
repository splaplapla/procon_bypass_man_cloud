#!/bin/bash

bundle exec rails assets:precompile
bundle exec rails s -p ${PORT:-3000} -e production
