FROM ubuntu:16.04

RUN apt-get update && apt-get -y install \
      automake \
      build-essential \
      cmake \
      curl \
      git \
      zip \
      unzip \
      checkinstall \
      ruby2.3 \
      ruby2.3-dev \
      rake \
      irb \
      rubygems

RUN gem install bundler

RUN useradd -ms /bin/bash docker
RUN mkdir -p /home/docker/.ssh
RUN ssh-keyscan github.com > /home/docker/.ssh/known_hosts
RUN chown -R docker:docker /home/docker/.ssh
USER docker

WORKDIR /build

CMD bundle install --binstubs --path .bundle/gems && make deb
