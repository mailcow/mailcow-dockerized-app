FROM python:3.6 as develop-stage
LABEL maintainer "Zekeriya Akgül <zkry.akgul@gmail.com>"

RUN DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get dist-upgrade -y && apt-get install -y \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
COPY source/requirements.txt .
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
ENV FLASK_ENV="docker"

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]