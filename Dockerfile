# Use an Ubuntu-based Ruby image
FROM ruby:3.2

# Set the working directory
WORKDIR /app

# Install MySQL client and development libraries
RUN apt-get update -qq && \
    apt-get install -y default-mysql-client libmysqlclient-dev

# Set argument variables
ARG DATABASE_URL
ARG ACCESS_TOKEN
ARG REPO_FULL_NAME

# Set environment variables
ENV DATABASE_URL=$DATABASE_URL
ENV ACCESS_TOKEN=$ACCESS_TOKEN
ENV REPO_FULL_NAME=$REPO_FULL_NAME

# Copy the Gemfile and Gemfile.lock
COPY Gemfile* /app/

# Install dependencies
RUN bundle config set --local without 'development test' && \
    bundle install --jobs $(nproc) --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem

# Copy the rest of the application
COPY . /app/

# Run the migration and sync GitHub Repo Data scripts
CMD bundle exec rails runner "RetryableRake.db_create" && \
    bundle exec rails runner "RetryableRake.db_migrate" && \
    bundle exec rails runner "SyncGithub.run!"