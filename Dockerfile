FROM ubuntu

ENV DEV false

RUN apt-get update && apt-get install -y ucspi-tcp jq curl

RUN wget -qO /usr/local/bin/websocat https://github.com/vi/websocat/releases/latest/download/websocat.x86_64-unknown-linux-musl && chmod a+x /usr/local/bin/websocat

EXPOSE 3000

COPY . /app

CMD [ "/app/start.sh" ]
