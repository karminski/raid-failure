# Dockerfile
# Dockerfile for raid-failure
#
# @version 190310:2
# @author  karminski <code.karminski@outlook.com>
#

# base info
FROM docker.io/library/nginx:1.15.9-alpine
MAINTAINER karminski <code.karminski@outlook.com>
USER root

# init base environment
RUN mkdir /data
RUN mkdir /data/repo
RUN mkdir /data/tmp
RUN mkdir /data/tmp/nginx

# add required lib
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*


# copy config to nginx folder
COPY ./config/nginx/nginx.conf /etc/nginx/
COPY ./config/nginx/raid-failure.public.conf /etc/nginx/vhost/

# copy repo
COPY ./ /data/repo/raid-failure/


# define health check
HEALTHCHECK --interval=5s --timeout=3s CMD curl -fs http://127.0.0.1:10080/status?src=docker_health_check -H"Host:raid-failure.eth6.org" || exit 1

# run nginx
EXPOSE 10080
STOPSIGNAL SIGTERM
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]