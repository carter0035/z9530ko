#!/bin/sh
##

# Set ARG
ARCH="64"
mv /root/PurpleProfessional.zip /root/purple
unzip /root/purple/PurpleProfessional.zip
rm -rf /root/PurpleProfessional.zip
DOWNLOAD_PATH="/tmp/X2ray"
mkdir -p ${DOWNLOAD_PATH}
cd ${DOWNLOAD_PATH} || exit

TAG=$(wget --no-check-certificate -qO- https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep 'tag_name' | cut -d\" -f4)
if [ -z "${TAG}" ]; then
    echo "Error: Get xray latest version failed" && exit 1
fi
echo "The xray latest version: ${TAG}"

# Download files
XRAY_FILE="Xray-linux-${ARCH}.zip"
DGST_FILE="Xray-linux-${ARCH}.zip.dgst"
echo "Downloading binary file: ${XRAY_FILE}"
echo "Downloading binary file: ${DGST_FILE}"

# TAG=$(wget -qO- https://raw.githubusercontent.com/v2fly/docker/master/ReleaseTag | head -n1)
wget -O ${DOWNLOAD_PATH}/xray.zip https://github.com/XTLS/Xray-core/releases/download/${TAG}/${V2RAY_FILE} >/dev/null 2>&1
wget -O ${DOWNLOAD_PATH}/xray.zip.dgst https://github.com/XTLS/Xray-core/releases/download/${TAG}/${DGST_FILE} >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE} ${DGST_FILE}" && exit 1
fi
echo "Download binary file: ${XRAY_FILE} ${DGST_FILE} completed"

# Check SHA512
LOCAL=$(openssl dgst -sha512 xray.zip | sed 's/([^)]*)//g')
STR=$(cat < xray.zip.dgst | grep 'SHA512' | head -n1)

if [ "${LOCAL}" = "${STR}" ]; then
    echo " Check passed" && rm -fv xray.zip.dgst
else
    echo " Check have not passed yet " && exit 1
fi

# Prepare
echo "Prepare to use"
unzip xray.zip && chmod +x xray

unzip xray.zip && chmod +x xray
mv xray geosite.dat geoip.dat /root/xray/

# Set config file
cat <<EOF >/root/xray/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 23323,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                    "id": "65f87cfd-6c03-45ef-bb3d-9fdacec80a9a",
                    "level": 0,
                    "alterId": 0,
                    "email": "love@xray.com"
                    }
                ],
                "disableInsecureEncryption": false
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": false,
                    "path": "/ape"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
EOF

# Clean
cd ~ || return
echo "Install done"

# Run v2ray
#/usr/bin/v2ray -config /etc/v2ray/config.json
/root/xray/xray run -c /root/xray/config.json
echo /purple/page.html
cat /purple/page.html
rm -rf /etc/nginx/sites-enabled/default

/bin/bash -c /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

