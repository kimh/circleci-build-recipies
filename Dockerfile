FROM From phusion/passenger-ruby21:latest

RUN apt-get update
RUN apt-get install mysql-server

WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install
