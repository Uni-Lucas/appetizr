# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

ARG DB_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD
ARG DB_PORT

ENV PQL_HOST=$DB_HOST
ENV PQL_NAME=$DB_NAME
ENV PQL_USER=$DB_USER
ENV PQL_PASSWORD=$DB_PASSWORD
ENV PQL_PORT=$DB_PORT
# Set production environment
ENV RAILS_ENV="production" \
    SECRET_KEY_BASE="0dd007bde7e726d657a421f5c14a0ba69e2e6490c542173f41b9eae6c93186bd1981ec7da02d8b345c2260cab6cb66b9c1264bf825b49242bcb961cd2c11d4f3" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    POSTGRESQL_ADDON_HOST="${PQL_HOST}" \
    POSTGRESQL_ADDON_DB="${PQL_NAME}" \
    POSTGRESQL_ADDON_USER="${PQL_USER}" \
    POSTGRESQL_ADDON_PASSWORD="${PQL_PASSWORD}" \
    POSTGRESQL_ADDON_PORT="${PQL_PORT}"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config 

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
RUN chown -R rails:rails /rails/public
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server"]
