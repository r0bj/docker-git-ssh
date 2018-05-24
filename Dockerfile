FROM alpine:3.7

RUN apk add --no-cache git openssh bash
COPY docker-entrypoint.sh /docker-entrypoint.sh 
RUN chmod +x /docker-entrypoint.sh

RUN sed -r -e '/^#?PasswordAuthentication/c\PasswordAuthentication no' -e '/^#?PermitRootLogin/c\PermitRootLogin no' -e '/^#?ChallengeResponseAuthentication/c\ChallengeResponseAuthentication no' -i /etc/ssh/sshd_config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
