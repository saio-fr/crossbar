FROM vinelab/crossbar
MAINTAINER Alexis Terrat <alexisterrat@gmail.com>
COPY ./config.json /.crossbar/config.json
CMD crossbar start --cbdir /.crossbar