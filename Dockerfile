FROM fedora:29

ENV VERSION=1.0

LABEL description="vsftpd + Fedora 29" \
      maintainer="stefan.gotkowski@gmail.com" \
      license="GNU v2" \
      version="$VERSION"

RUN yum install -y vsftpd &&\
    yum clean all

RUN mkdir /var/certificates &&\
    mkdir /etc/vsftpd/configs

RUN chmod 757 -R /var/ftp

ENV pasv_enable=YES
ENV pasv_min_port=21100
ENV pasv_max_port=21110
ENV userlist_file=/etc/vsftpd/configs.user_list
ENV background=NO
ENV listen=NO
ENV pam_service_name=vsftpd
ENV listen_ipv6=YES
ENV local_enable=YES
ENV local_root=/var/ftp
ENV download_enable=YES
ENV write_enable=YES
ENV dirmessage_enable=YES
ENV local_umask=022

COPY vsftpd.conf /etc/vsftpd/

COPY docker-entrypoint.sh /usr/local/bin/
RUN  chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 20 21 $pasv_min_port-$pasv_max_port
