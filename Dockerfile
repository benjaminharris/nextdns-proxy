FROM debian:11

RUN apt-get update && apt-get install -y locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN apt-get install -fy curl dnsutils apt-transport-https
RUN curl -o /usr/share/keyrings/nextdns.gpg https://repo.nextdns.io/nextdns.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/nextdns.gpg] https://repo.nextdns.io/deb stable main" | tee /etc/apt/sources.list.d/nextdns.list
RUN apt update
RUN apt install nextdns
COPY run.sh /var/nextdns/run.sh

HEALTHCHECK --interval=60s --timeout=10s --start-period=5s --retries=1 \
    CMD dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io && dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io

CMD ["/var/nextdns/run.sh"]
