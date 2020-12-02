# Wordpress-Docker-Template

## Files to create a Wordpress proyect with docker-compose using MySQL and Apache.

To build this docker-compose you should have docker installed in your system and set the env variables.

**Run:**

```console
docker-compose up -d
```
This project is thinking for work with haproxy.  [https://www.haproxy.com/]

The conf file must to look as follows.

``` console
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
        ssl-dh-param-file /etc/haproxy/dhparams.pem

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http
        
frontend http_front
        mode http
        # Let the real servers know this was originally a HTTPS request
        http-request add-header X-Forwarded-Proto https
        bind 0.0.0.0:80
        bind 0.0.0.0:443 ssl crt /etc/haproxy/certs/${DOMAIN}.pem
        http-request redirect scheme https unless { ssl_fc }
        timeout client 10s
        use_backend server if { hdr(host) -i www.${DOMAIN}.com }
        use_backend server if { hdr(host) -i ${DOMAIN}.com }

backend server
        mode http
        server refaccionariahp_server 127.0.0.1:443 
        timeout server 10s
        timeout connect 10s

```
