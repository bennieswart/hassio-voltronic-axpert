ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --update --no-cache    \
        jq                         \
        python3                    \
 && python3 -m ensurepip           \
 && pip3 install crcmod paho-mqtt

COPY run.sh monitor.py /

CMD ["/run.sh"]
