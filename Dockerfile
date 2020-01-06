FROM openresty/openresty:alpine

RUN apk add --no-cache curl perl \
  && opm get leafo/pgmoon ledgetech/lua-resty-http

COPY . /usr/local/openresty/nginx
