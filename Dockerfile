FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libmariadbd-dev nodejs mc
RUN mkdir /usr/app
WORKDIR /usr/app
ADD Gemfile /usr/app/Gemfile
ADD Gemfile.lock /usr/app/Gemfile.lock
RUN bundle install
ADD . /usr/app
