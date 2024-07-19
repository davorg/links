FROM perl:latest
LABEL maintainer="dave@perlhacks.org"

COPY . /links
RUN cd /links && cpanm --installdeps .
WORKDIR /links
