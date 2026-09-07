ARG RUBY_IMAGE=ruby:3.4.10-slim-trixie@sha256:9d50d98e61ccbe4f1ef436349911e09b53c42a00364bcd3bda6ac107abc29528

FROM ${RUBY_IMAGE} AS gems

WORKDIR /app

# Keep the discarded build toolchain eligible for Debian security updates.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3 \
    && rm -rf /usr/local/bundle/cache

FROM ${RUBY_IMAGE}

WORKDIR /app

COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY jenkins ./jenkins/
COPY jenkins_job.rb ./

ENTRYPOINT ["ruby", "/app/jenkins_job.rb"]
