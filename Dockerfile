FROM ruby:3.4.4-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy application code
COPY . .

ENV RACK_ENV=production
EXPOSE 80

# Start Puma server
CMD ["bundle", "exec", "puma", "-p", "80", "-t", "3:3"]
