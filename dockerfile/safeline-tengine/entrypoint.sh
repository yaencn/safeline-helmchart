#!/bin/bash
source /etc/profile

sleep 50

mkdir -p /usr/local/nginx/cache && chown -R nginx /usr/local/nginx/cache

local_lib_dir="/usr/local/lib"

etc_nginx="/etc/nginx/"
root_nginx="/root/nginx/*"
etc_nginx_certs="/etc/nginx/certs/"
etc_nginx_custom_params="/etc/nginx/custom_params/"
if [ ! "$(ls -A $etc_nginx)" ]; then
    cp -r $root_nginx $etc_nginx
fi

cp -r /root/nginx/safeline_unix.conf $etc_nginx/safeline_unix.conf
cp -r /root/nginx/tx_ignore_types $etc_nginx/tx_ignore_types
sed -i "s/\$TCD_SNSERVER/${TCD_SNSERVER}/g" /etc/nginx/safeline_unix.conf
sed -i 's/ssl_ciphers "EECDH/ssl_ciphers "@SECLEVEL=1 EECDH/' /etc/nginx/nginx.conf

mkdir -p /etc/nginx/conf.d/

#if [[ -e "/etc/nginx/conf.d/_safeline_sites.conf" ]]; then
if [[ $TCD_STREAM == "true" ]]; then
  mkdir -p $etc_nginx/sites-enabled-stream
  cp -r /root/nginx/sites-enabled-stream/generated $etc_nginx/sites-enabled-stream/generated
  sed -i "/t1k_append_header/d" $etc_nginx/sites-enabled-stream/IF_backend_*
  sed -i 's/include \/etc\/nginx\/sites-enabled\/generated;/include \/etc\/nginx\/sites-enabled-stream\/generated;/' $etc_nginx/nginx.conf
else
  mkdir -p $etc_nginx/sites-enabled
  cp -r /root/nginx/sites-enabled/generated $etc_nginx/sites-enabled/generated
  sed -i "/t1k_append_header/d" $etc_nginx/sites-enabled/IF_backend_*
  sed -i 's/include \/etc\/nginx\/sites-enabled-stream\/generated;/include \/etc\/nginx\/sites-enabled\/generated;/' $etc_nginx/nginx.conf
fi

mkdir -p $etc_nginx_certs
chmod 777 $etc_nginx_certs  # managed by mgt-api webserver
mkdir -p $etc_nginx_custom_params

cd /app; ./tcd &

exec "$@"