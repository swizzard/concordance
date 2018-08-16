FROM postgrest/postgrest:latest

COPY ./postgrest.conf /etc/postgrest.conf

RUN apt-get update                                         \
    && apt-get upgrade -y                                  \
    && apt-get install -y curl postgresql-client libpq-dev \
    && /home/install.sh

CMD /home/migrate.sh && exec postgrest /etc/postgrest.conf
