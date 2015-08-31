FROM vinelab/crossbar
RUN mkdir -p /usr/local/bin/crossbar/.crossbar
COPY ./crossbar/config.json /usr/local/bin/crossbar/.crossbar/config.json
WORKDIR /usr/local/bin/crossbar
EXPOSE 8080 8081
CMD crossbar start
