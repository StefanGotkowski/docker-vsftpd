FROM fedora:29

MAINTAINER Stefan Gotkowski <stefan.gotkowski@gmail.com>

LABEL Description="vsftpd + Fedora 29" \
      License="GNU v2"

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

# Add startup (+ user configurations)
ADD start.sh /usr/sbin/start.sh
RUN chmod +x /usr/sbin/start.sh

# secure_chroot_dir
RUN mkdir -p /var/run/vsftpd/empty

# Open port
EXPOSE 21

# Startup script
ENTRYPOINT ["sh", "/usr/sbin/start.sh"]
