FROM phusion/passenger-customizable AS base

RUN /pd_build/ruby-2.6.*.sh \
    && /pd_build/nodejs.sh

RUN apt update \
    && apt upgrade -y

ADD --chown=app:app Gemfile Gemfile.lock /application/

WORKDIR /application

RUN gem install bundler \
    && bundle config set deployment 'true' \
    && bundle config set without 'development test' \
    && bundle install --jobs 4

RUN apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chown=app:app . /application

RUN mv config/database.yml.production config/database.yml

FROM base as appserver

RUN rm /etc/nginx/sites-enabled/default \
    && rm -f /etc/service/nginx/down

RUN echo "server { \n\
              listen 80; \n\
              root /application/public; \n\
              passenger_enabled on; \n\
              passenger_user app; \n\
              passenger_ruby /usr/bin/ruby2.6; \n\
              passenger_app_env production; \n\
          }" > /etc/nginx/sites-enabled/webapp.conf \
  && echo "env POSTGRES_PASSWORD;" > /etc/nginx/main.d/postgres-env.conf

EXPOSE 80

FROM base as worker

RUN mkdir /etc/service/sidekiq \
    && echo "#!/bin/bash \n\
    cd /application \n\
    exec /sbin/setuser app bundle exec sidekiq -e production -c 16" \
    > /etc/service/sidekiq/run \
    && chmod +x /etc/service/sidekiq/run