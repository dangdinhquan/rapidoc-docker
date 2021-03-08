# FROM node:alpine AS builder

# WORKDIR /opt/app

# # From: https://hub.docker.com/r/jfyne/node-alpine-yarn/dockerfile
# # added: git, openssh
 
# RUN apk add --no-cache --virtual .build-deps \
#     ca-certificates \
#     git \
#     openssh \
#     wget \
#     tar && \
#     cd /usr/local/bin && \
#     wget https://yarnpkg.com/latest.tar.gz && \
#     tar zvxf latest.tar.gz && \
#     ln -s /usr/local/bin/dist/bin/yarn.js /usr/local/bin/yarn.js && \
#     mkdir -p /opt/app && \
#     git clone https://github.com/mrin9/RapiDoc.git /opt/app/RapiDoc && \
#     apk del .build-deps 
    
# RUN cd /opt/app/RapiDoc && \
#     yarn install && \
#     yarn build 

FROM nginx:alpine

USER 0
COPY ./docker/* /usr/share/nginx/html
COPY ./docker/default.conf /etc/nginx/conf.d

RUN mkdir /opt/app/ && \
    mkdir -p /usr/share/nginx/html/openapi
ADD docker /opt/app
RUN mv /opt/app/html/* /usr/share/nginx/html/

RUN mkdir -p /var/cache/nginx && touch /var/run/nginx.pid

RUN chmod +x /opt/app/boot.sh && \
    chmod +x /etc/nginx/conf.d/default.conf && \
    chown -R 1001:0 /opt/app/boot.sh && \
    chown -R 1001:0 /usr/share/nginx/html && \
    chgrp -R 0 /usr/share/nginx/html && \
    chmod -R g=u /usr/share/nginx/html && \
    chgrp -R 0 /var/cache/nginx && \
    chmod -R g=u /var/cache/nginx && \
    chgrp -R 0 /var/run/nginx.pid && \
    chmod -R g=u /var/run/nginx.pid

ENTRYPOINT [ "/opt/app/boot.sh" ]

USER 1001
