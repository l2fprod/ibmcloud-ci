FROM alpine:3.12 as builder

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
VOLUME /app
ENV TERM xterm-256color
WORKDIR /app
ENTRYPOINT [ "bash", "-l" ]
