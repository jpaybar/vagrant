#!/bin/sh

echo 'Setting Proxy for Docker and systemd...'

mkdir -p /etc/systemd/system/docker.service.d
touch /etc/systemd/system/docker.service.d/http-proxy.conf 

cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://10.40.56.3:8080"
Environment="HTTPS_PROXY=http://10.40.56.3:8080"
Environment="NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.39.0/24,192.168.49.0/24"
EOF

systemctl daemon-reload
systemctl restart docker