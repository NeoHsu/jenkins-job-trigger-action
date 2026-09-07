FROM ruby:3.4.10-bookworm@sha256:719732d30910d44c7173cde5010bf33c8f279573bd8908e2ff2b49272b7d55ce

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

COPY jenkins ./jenkins/
COPY jenkins_job.rb ./

ENTRYPOINT [ "ruby", "/app/jenkins_job.rb" ]
