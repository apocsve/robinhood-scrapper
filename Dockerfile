FROM python:3.7-stretch

LABEL mantainer="Rafael <rafael@booug.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
		netcat \
		cron \
		supervisor \
	&& rm -rf /var/lib/apt/lists/*

## Supervisor
COPY ./project/supervisord/supervisord.conf /etc/supervisord.conf

## Cron
COPY ./project/cron/crontab.txt /etc/cron.d/scrapper-cron
RUN chmod 0644 /etc/cron.d/scrapper-cron
RUN crontab /etc/cron.d/scrapper-cron

## Logs
RUN mkdir -p /var/log/supervisord
RUN touch /var/log/supervisord/supervisord.log

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY wait.sh /usr/local/bin/wait.sh
COPY ./project/scripts/run_instruments_scraper.sh /usr/local/bin/run_instruments_scraper.sh
COPY ./project/scripts/run_worker_popularity.sh /usr/local/bin/run_worker_popularity.sh
COPY ./project/scripts/run_worker_quote.sh /usr/local/bin/run_worker_quote.sh
COPY ./project/scripts/run_worker_fundamentals.sh /usr/local/bin/run_worker_fundamentals.sh

RUN mkdir /app

WORKDIR /app

ENTRYPOINT wait.sh && docker-entrypoint.sh