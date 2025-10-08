# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.9
FROM ruby:${RUBY_VERSION}-slim AS base

# Minimal production env
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT=1 \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

WORKDIR /rails

# Runtime OS deps only
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips tzdata ca-certificates && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ================================
# Build stage
# ================================
FROM base AS build

# Build-time deps (for native gems and JS build)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libyaml-dev pkg-config \
      python-is-python3 node-gyp && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node 20 + enable Corepack (Yarn)
ARG NODE_VERSION=20.19.5
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    rm -rf /tmp/node-build-master
RUN corepack enable

# Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle /usr/local/bundle/ruby/*/cache /usr/local/bundle/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# JS deps (works with or without lockfiles)
COPY package.json ./
# Copy lockfiles if they exist (using wildcards to avoid errors if missing)
COPY yarn.loc[k] ./
COPY package-lock.jso[n] ./
RUN if [ -f yarn.lock ]; then yarn install --immutable; \
    elif [ -f package-lock.json ]; then npm ci; \
    else echo "No JS lockfile found; installing with yarn"; yarn install; fi

# App code
COPY . .

# Bootsnap cache for app code
RUN bundle exec bootsnap precompile app/ lib/

# Assets precompile (no master key needed for this step)
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Drop node_modules from the final image
RUN rm -rf node_modules

# ================================
# Final image
# ================================
FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Rails entrypoint handles db:prepare safely
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Railway exposes $PORT (commonly 8080)
ENV PORT=8080
EXPOSE 8080

# Start the app with Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
