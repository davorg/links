FROM perl:latest
LABEL maintainer="dave@perlhacks.org"

COPY .. /links
RUN cd /links
RUN cpanm --installdeps . || cat /root/.cpanm/work/*/build.log
WORKDIR /links
