# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.9
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential curl libpq-dev libjemalloc2 libvips \
      libyaml-dev nodejs npm postgresql-client tzdata && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Copy and set entrypoint
COPY bin/docker-entrypoint /rails/bin/
RUN chmod +x /rails/bin/docker-entrypoint

# Create user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Expose port
ENV PORT=8080
EXPOSE 8080

# Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start command - simple and reliable
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]