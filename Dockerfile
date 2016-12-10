FROM alpine:3.4

RUN apk add --no-cache git openssh bash
COPY docker-entrypoint.sh /docker-entrypoint.sh 
RUN chmod +x /docker-entrypoint.sh

RUN apk add --no-cache tzdata && cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo "Europe/Warsaw" >/etc/timezone && apk del tzdata

RUN sed -r '/^#?PasswordAuthentication/c\PasswordAuthentication no' -i /etc/ssh/sshd_config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
