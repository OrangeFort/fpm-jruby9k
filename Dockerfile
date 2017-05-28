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
USER docker
WORKDIR /build

CMD bundle install --binstubs .bundle/bin --path .bundle/gems && make --makefile debian.makefile
