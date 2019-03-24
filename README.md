# docker-vsftpd

vsftpd + Fedora 29

### Service
 
`vsftpd (v3.0.3)`

### Arguments

`USERS` multiple users with passwords ( exemple: ```-e USERS="user1:pass1;user2:pass2"``` ) 

`VSFTPD_CONFIG` please check all vsftpd [configs](http://vsftpd.beasts.org/vsftpd_conf.html) ( exemple: ```-e listen="NO"``` ) 
      
### Launch exemple

```bash 
docker run --name ftp -tdi -p 21:21 -p 21100-21110:21100-21110 \
 -e listen="NO" \
 -e listen_ipv6="YES" \
 -e local_root="/var/ftp" \
 -e local_umask="022" \
 -e local_enable="YES" \
 -e write_enable="YES" \
 -e dirmessage_enable="YES" \
 -e vsftpd_log_file="/var/log/vsftpd.log" \
 -e ssl_enable="YES" \
 -e rsa_cert_file=/var/certificates/cert.pem \
 -e rsa_private_key_file=/var/certificates/priv.pem \
 -e pasv_enable="YES" \
 -e pasv_min_port="21100" \
 -e pasv_max_port="21110" \
 -e USERS="user1:pass1;user2:pass2" \
-v /data/shared:/var/ftp \
-v /data/log/ftp:/var/log \
-v /data/certificates:/var/certificates \
-v /data/vsftpd:/etc/vsftpd/configs \
stefang/docker-vsftpd
```

### Chech Errors

```bash
docker logs ftp
```

### Potential error

Users and password doesn't support characters like : and ;
    
### License

GNU General Public License v2.0

    
[Build state](https://cloud.docker.com/repository/docker/stefang/docker-vsftpd/builds)
