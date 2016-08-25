# Alpine would be smaller but doesn't satisfy rdiscount dependencies
FROM ruby:2.3.1

RUN mkdir /app
WORKDIR /app

RUN gem install bundler
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle check || bundle install

ADD . /app
