FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

RUN export DEBIAN_FRONTEND=noninteractive

# please keep pkgs sorted
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends --fix-missing \
    build-essential \
    bundler \
    clang-format \
    clang-tidy \
    cmake \
    ditaa \
    g++ \
    gcc-riscv64-linux-gnu \
    gcc-riscv64-unknown-elf \
    gdb \
    gh \
    git \
    less \
    libc6-dev-riscv64-cross \
    libelf-dev \
    libgmp-dev \
    libnewlib-dev\
    libyaml-dev \
    nodejs \
    npm \
    parallel \
    python3 \
    python3-pip \
    python3.12-venv \
    ruby \
    ruby-dev \
    shellcheck && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/*

# Install Ruby gems
COPY Gemfile Gemfile.lock /tmp/
RUN cd /tmp && \
    bundle config set --global path /opt/gems && \
    bundle config set --global jobs $(nproc) && \
    bundle config set --global with development && \
    bundle install && \
    rm -f /tmp/Gemfile /tmp/Gemfile.lock

# Install Python packages in a virtual environment
COPY requirements.txt /tmp/
RUN /usr/bin/python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -f /tmp/requirements.txt

# Install Node.js packages
RUN mkdir -p /opt/npm
COPY package.json package-lock.json /opt/npm/
RUN cd /opt/npm && npm install && \
    rm -f /opt/npm/package.json /opt/npm/package-lock.json

WORKDIR /workspace

# Set environment variables
ENV GEM_HOME=/opt/gems
ENV PATH=/opt/gems/bin:/opt/venv/bin:/opt/npm/node_modules/.bin:$PATH
ENV VIRTUAL_ENV=/opt/venv
ENV NODE_PATH=/opt/npm/node_modules

WORKDIR /workspace
