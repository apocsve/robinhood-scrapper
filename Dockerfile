FROM python:3.7-stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
		netcat \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /app

WORKDIR /app

CMD ["./run_worker.sh"]