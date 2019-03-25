# docker-vsftpd

vsftpd + Fedora 29

### Service
 
`vsftpd` (v3.0.3)

### Environments

`USERS` multiple users with passwords ( exemple: ```-e USERS="user1:pass1;user2:pass2"``` ) 

`OTHERS` please check all vsftpd [configs](http://vsftpd.beasts.org/vsftpd_conf.html) ( example: ```-e anonymous_enable="YES"``` ) 
      
### Basic FTP

```bash 
docker run --name ftp -tdi \
 -p 21:21 -p 21100-21110:21100-21110 \
 -e USERS="user1:pass1" \
stefang/vsftpd
```

### All Volumes

`/var/ftp` directory of ftp up/down files
`/var/log` all logs
`/var/certificates` directory for certficates
`/etc/vsftpd/configs` vsftpd.conf/user_list files

### [Example] FTP with environments

```bash 
docker run --name ftp -tdi \
 -p 18:21 -p 21100-21110:21100-21110 \
   -e USERS="user1:pass1" \
   -e connect_from_port_20=YES \
   -e hide_ids={pub} \
stefang/vsftpd
```


### [Example] FTP with volumes and environments

```bash 
docker run --name ftp -tdi \
 -p 21:21 -p 21100-21110:21100-21110 \
   -e USERS="user1:pass1" \
   -e ssl_enable="YES" \
   -e rsa_cert_file=/var/certificates/cert.pem \
   -e rsa_private_key_file=/var/certificates/priv.pem \
   -e xferlog_enable="YES" \
 -v /data/shared:/var/ftp \
 -v /data/log/ftp:/var/log \
 -v /data/certificates:/var/certificates \
stefang/vsftpd
```

### Chech Errors

```bash
docker logs ftp
```

### Potential error

Users and password doesn't support characters like : and ;
    
### License

GNU General Public License v2.0

    
[Build state](https://cloud.docker.com/repository/docker/stefang/vsftpd/builds)
