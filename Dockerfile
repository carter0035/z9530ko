FROM nginx:1.19.3-alpine
ENV TZ=Asia/Shanghai
WORKDIR /root
COPY configure.sh /root/configure.sh

RUN set -ex \
    && apk add  --no-cache --virtual .build-deps ca-certificates bash curl unzip php7 \
    && mkdir -p /root/purple /root/mqev /etc/nginx/ /etc/nginx/conf.d/ \
    && chmod +x /root/configure.sh
COPY PurpleProfessional.zip /root/purple/PurpleProfessional.zip
COPY mqev.zip /root/mqev/mqev.zip
COPY config/default.conf /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
CMD [ "/root/configure.sh" ]
