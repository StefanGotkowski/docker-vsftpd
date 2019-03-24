FROM fedora:29

LABEL description="vsftpd + Fedora 29" \
      maintainer="stefan.gotkowski@gmail.com" \
      license="GNU v2"

# Install service
#RUN yum -y update
RUN yum install -y vsftpd
RUN yum clean all

# Create all dirs
RUN mkdir /var/ftp/shared &&\
    mkdir /var/certificates &&\
    mkdir /etc/vsftpd/configs

# Add config file
ADD vsftpd.conf /etc/vsftpd/vsftpd.conf

# Add startup
ADD start.sh /usr/sbin/start.sh
RUN chmod +x /usr/sbin/start.sh

# secure_chroot_dir
RUN mkdir -p /var/run/vsftpd/empty

# Open port
EXPOSE 20 21

# Startup script
ENTRYPOINT ["sh", "/usr/sbin/start.sh"]
