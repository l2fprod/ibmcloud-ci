FROM node:19-alpine as builder

ENV LANG en_US.UTF-8
COPY install-base.sh install-base.sh
COPY install-ibmcloud.sh install-ibmcloud.sh
ARG GITHUB_TOKEN

RUN GITHUB_TOKEN=$GITHUB_TOKEN ./install-base.sh
RUN GITHUB_TOKEN=$GITHUB_TOKEN ./install-ibmcloud.sh
RUN rm -f install-base.sh install-ibmcloud.sh

RUN mkdir /app

FROM scratch
COPY --from=builder / /
COPY .bash_profile /root
COPY .bash_aliases /root
VOLUME /app
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
WORKDIR /app
ENTRYPOINT [ "bash", "-l" ]
