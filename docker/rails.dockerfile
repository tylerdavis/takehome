FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /sp-takehome
WORKDIR /sp-takehome
ADD Gemfile /sp-takehome/Gemfile
ADD Gemfile.lock /sp-takehome/Gemfile.lock
RUN bundle install
ADD . /sp-takehome
