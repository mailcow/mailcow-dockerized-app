FROM ubuntu:16.04

USER root

RUN DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get dist-upgrade -y && apt-get install -y \
  build-essential \
  curl \
  dnsutils \
  gcc \
  g++ \
  git \
  python-dev \
  python-pip \
  wget \
  gettext-base \
  language-pack-en \
  libcurl4-openssl-dev \
  liblua5.2-dev \
  libmysqlclient-dev \
  libxml2-dev \
  libxslt-dev \
  libxslt1-dev \
  mysql-client \
  pkg-config \
  lsof \
  net-tools \
  shared-mime-info \
  telnet \
  tzdata \
  supervisor \
  vim \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sync-engine
COPY ./sync-engine ./
RUN find . -name \*.pyc -delete
RUN pip install setuptools==44.0.0
RUN pip install pip==20.3.4
RUN pip install -r requirements_frozen.txt -e .
RUN useradd inbox && \
    mkdir -p /etc/inboxapp

ADD config.json /etc/inboxapp/config-env.json
ADD secrets.yml /etc/inboxapp/secrets-env.yml

RUN apt-get -y autoremove && apt-get clean &&\
    mkdir -p /var/lib/inboxapp/parts && mkdir -p /var/log/inboxapp && chown inbox:inbox /var/log/inboxapp &&\
    chown -R inbox:inbox /var/lib/inboxapp && chown -R inbox:inbox /opt/sync-engine

RUN mkdir -p /etc/sync-engine/inbox-start && mkdir -p /etc/sync-engine/inbox-api
ADD inbox-start.sh /etc/sync-engine/inbox-start/run
ADD inbox-api.sh /etc/sync-engine/inbox-api/run

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 5555
EXPOSE 5556
EXPOSE 3114

ENV \
  LANG="en_US.UTF-8" \
  LC_ALL="en_US.UTF-8" \
  PYTHONPATH=/opt/sync-engine

RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
