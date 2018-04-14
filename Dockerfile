FROM ruby:2.4.2-alpine3.6
MAINTAINER Udit Gupta "uditgupta.mail@gmail.com"

ADD . /app/

RUN gem install bundler --no-ri --no-rdoc && \
    apk --update add  ruby-dev build-base git && \
    cd /app ; bundle install && \
    apk --update add git

RUN chown -R nobody:nogroup /app
USER nobody

WORKDIR /app

CMD find_like --help