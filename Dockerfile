FROM alpine:3.5

RUN apk add --no-cache git openssh bash
COPY docker-entrypoint.sh /docker-entrypoint.sh 
RUN chmod +x /docker-entrypoint.sh

RUN sed -r '/^#?PasswordAuthentication/c\PasswordAuthentication no' -i /etc/ssh/sshd_config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
