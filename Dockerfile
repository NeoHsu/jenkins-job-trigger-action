FROM ruby:2.7-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && gem install bundler -v 2.2.17

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY jenkins ./jenkins/
COPY jenkins_job.rb ./

ENTRYPOINT [ "ruby", "/app/jenkins_job.rb" ]
