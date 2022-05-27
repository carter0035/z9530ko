FROM nginx:1.19.3-alpine
ENV TZ=Asia/Shanghai
WORKDIR /root
COPY configure.sh /root/configure.sh
COPY PurpleProfessional.zip /root/PurpleProfessional.zip
COPY config/default.conf /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
RUN set -ex \
    && apk add  --no-cache --virtual .build-deps ca-certificates bash curl unzip php7 \
    && mkdir -p /root/purple \
    && chmod +x /root/configure.sh

CMD [ "/root/configure.sh" ]
