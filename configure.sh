#!/bin/sh
##

# Set ARG
ARCH="64"
unzip /root/purple/PurpleProfessional.zip
rm -rf /root/PurpleProfessional.zip
mv /root/mqev.zip /root/mqev/mqev.zip
rm -rf /root/mqev.zip
cd /root/mqev || exit


# Prepare
echo "Prepare to use"
unzip mqev.zip && chmod +x mqev
rm -rf mqev.zip
# Set config file
cat <<EOF >/root/mqev/config.json
{
 "inbounds": [
    {
      "port": 23323,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "65f87cfd-6c03-45ef-bb3d-9fdacec80a9a",
            "alterId": 0
          }
        ],
        "disableInsecureEncryption": true
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/ape"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Clean
cd ~ || return
echo "Install done"

# Run
/root/mqev/mqev run -c /root/mqev/config.json
echo /purple/page.html
cat /purple/page.html
rm -rf /etc/nginx/sites-enabled/default

/bin/bash -c /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

