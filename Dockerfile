FROM ubuntu:noble

RUN apt-get update
RUN apt-get install curl gpg -y

RUN curl -sS https://package.perforce.com/perforce.pubkey | gpg --dearmor -o /usr/share/keyrings/perforce.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] http://package.perforce.com/apt/ubuntu noble release" > /etc/apt/sources.list.d/perforce.list

RUN apt-get update

RUN apt-get install helix-p4d -y
RUN apt-get clean

ARG DOCKER_USER=perforce
RUN addgroup --system $DOCKER_USER && adduser --system $DOCKER_USER

WORKDIR /
COPY docker-entrypoint.sh /
RUN chmod 500 /docker-entrypoint.sh
RUN chown $DOCKER_USER:$DOCKER_USER /docker-entrypoint.sh

# Make directories /p4data and /p4ssl
RUN mkdir /p4data /p4ssl
RUN chown $DOCKER_USER:$DOCKER_USER /p4data /p4ssl
RUN chmod 700 /p4data /p4ssl

USER $DOCKER_USER

# Set envs
ENV P4USER=$DOCKER_USER
ENV P4PORT=ssl:1666
ENV P4NAME=myserver
ENV P4SSLDIR=/p4ssl
ENV P4ROOT=/p4data

ENTRYPOINT ["/docker-entrypoint.sh"]