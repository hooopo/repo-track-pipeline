# Use an Ubuntu-based Ruby image
FROM ruby:3.2

# Set the working directory
WORKDIR /

# Install MySQL client and development libraries
RUN apt-get update -qq && \
    apt-get install -y default-mysql-client default-libmysqlclient-dev

# Set argument variables
ARG DATABASE_URL
ARG ACCESS_TOKEN
ARG REPO_FULL_NAME

# Set environment variables
ENV DATABASE_URL=$DATABASE_URL
ENV ACCESS_TOKEN=$ACCESS_TOKEN
ENV REPO_FULL_NAME=$REPO_FULL_NAME

# Copy the Gemfile and Gemfile.lock
COPY . .

# Install dependencies
RUN bundle config set --local without 'development test' && \
    bundle install --jobs $(nproc) --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem

# Run the migration and sync GitHub Repo Data scripts
CMD ls && pwd && bundle exec rails runner "RetryableRake.db_create" && \
    bundle exec rails runner "RetryableRake.db_migrate" && \
    bundle exec rails runner "SyncGithub.run!"