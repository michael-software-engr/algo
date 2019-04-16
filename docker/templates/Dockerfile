FROM ubuntu
MAINTAINER michael

ARG DEBIAN_FRONTEND=noninteractive
# Get rid of warning:
#   debconf: delaying package configuration, since apt-utils is not installed
RUN apt-get update && apt-get install --yes --no-install-recommends apt-utils

RUN apt-get update && apt-get upgrade --yes && apt-get update

# Ruby package dependencies (https://github.com/rbenv/ruby-build/wiki):
RUN apt-get install --yes \
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
  zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev

# App package dependencies
ARG xviewer_package
RUN [ -n "$xviewer_package" ]
RUN apt-get install --yes curl git graphviz graphviz-dev "$xviewer_package"

ARG docker_uid
ARG docker_user
RUN [ -n "$docker_uid" ] && [ -n "$docker_user" ] && \
  useradd --create-home --uid "$docker_uid" "$docker_user"

USER "$docker_user"
ENV HOME "/home/$docker_user"
WORKDIR "$HOME"

# Ruby version manager:
RUN git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$HOME/.bash_profile"
RUN echo 'eval "$(rbenv init -)"' >> "$HOME/.bash_profile"

ENV PATH "$HOME/.rbenv/bin:$PATH"
RUN eval "$(rbenv init -)"

# rbenv plugins
RUN [ -n "$(rbenv root)" ]
RUN mkdir -p "$(rbenv root)/plugins"
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)/plugins/ruby-build"
RUN git clone https://github.com/rkh/rbenv-update.git "$(rbenv root)/plugins/rbenv-update"
RUN rbenv update

ARG ruby_version
RUN [ -n "$ruby_version" ] && rbenv install --verbose "$ruby_version" && rbenv global "$ruby_version"
RUN eval "$(rbenv init -)" && \
  gem install --no-document i18n activesupport-inflector ruby-graphviz && \
  ruby -v

WORKDIR "/home/$docker_user/algo"
ENV __docker__ true
