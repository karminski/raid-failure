#!/bin/sh
# @version:    200109:1


# config 
REPO_NAME="raid-failure"
VERSION="0.0.2"
DEPLOY_LOCATION="/data/repo"
LOGS_LOCATION="/data/logs"
NGINX_LOCATION="/usr/bin/nginx"
NGINX_CONFIG_LOCATION="/data/apps/nginx/conf/vhost/"
PROXY_CONFIG_NAME="raid-failure.eth6.org-public.conf"
CRONJOB_CONFIG_NAME="raid-failure-cert-renew.cron"
IN_CONTINER_PORT="10080"
HOST_PORT="127.0.0.1:10080"


# init
mkdir $LOGS_LOCATION/$REPO_NAME -p
ln -s $LOGS_LOCATION/$REPO_NAME $DEPLOY_LOCATION/$REPO_NAME/logs

# link proxy config
ln -s $DEPLOY_LOCATION/$REPO_NAME/config/proxy/$PROXY_CONFIG_NAME $NGINX_CONFIG_LOCATION
ls -alh $NGINX_CONFIG_LOCATION | grep --color $PROXY_CONFIG_NAME
`$NGINX_LOCATION -t`
`$NGINX_LOCATION -s reload`

# link cron job
ln -s $DEPLOY_LOCATION/$REPO_NAME/config/cron/$CRONJOB_CONFIG_NAME /etc/cron.d/

# build and run image
docker build ./ -t $REPO_NAME:$VERSION
docker images | grep --color $REPO_NAME
docker run -d -p $HOST_PORT:$IN_CONTINER_PORT/tcp --name $REPO_NAME $REPO_NAME:$VERSION 
docker ps | grep --color $REPO_NAME