FROM fedora:29

LABEL description="vsftpd + Fedora 29" \
      maintainer="stefan.gotkowski@gmail.com" \
      license="GNU v2"

RUN yum install -y vsftpd &&\
    yum clean all

RUN mkdir /var/ftp/shared &&\
    mkdir /var/certificates &&\
    mkdir /etc/vsftpd/configs

VOLUME /var/ftp
VOLUME /var/log
VOLUME /var/certificates
VOLUME /etc/vsftpd/configs

COPY vsftpd.conf /etc/vsftpd/

COPY docker-entrypoint.sh /usr/local/bin/
RUN    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 20 21
