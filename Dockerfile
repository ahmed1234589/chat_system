FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client yarn
RUN mkdir /chat_system
WORKDIR /chat_system
COPY Gemfile /chat_system/Gemfile
COPY Gemfile.lock /chat_system/Gemfile.lock
COPY package.json /chat_system/package.json
COPY yarn.lock /chat_system/yarn.lock
RUN gem install bundler -v '2.2.15'
RUN bundle install
RUN yarn install --check-files
COPY . /sample_rails_application
EXPOSE 3000