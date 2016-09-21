FROM ubuntu:16.04
MAINTAINER Dmitry Mozzherin
ENV LAST_FULL_REBUILD 2016-08-06

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y ruby2.3 ruby2.3-dev ruby-switch \
      build-essential openssh-server git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo 'gem: --no-rdoc --no-ri >> "$HOME/.gemrc"'

RUN gem install bundler && mkdir /app && mkdir /var/run/sshd

WORKDIR /app

COPY Gemfile /app
COPY gnresolver_client.gemspec /app
COPY lib/gnresolver_client/version.rb /app/lib/gnresolver_client/version.rb
RUN bundle

COPY . /app

CMD ["/usr/sbin/sshd", "-D"]


