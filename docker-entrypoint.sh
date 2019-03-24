#!/bin/bash
#######################################################
# Author  : Stefan Gotkowski                          #
# License : GPL v2                                    #
#######################################################

VERSION=1.0

getMessageWithTime()
{
  echo -e $(date +'[%d/%m/%y - %H:%M:%S] ') $1
}

# Creation of the container
if [ ! -e /etc/vsftpd/configs/vsftpd.conf ]; then
  # All configs
  declare -a configs=("allow_anon_ssl" "anon_mkdir_write_enable" "anon_other_write_enable" "anon_upload_enable" "anon_world_readable_only" "anonymous_enable" "ascii_download_enable" "ascii_upload_enable" "async_abor_enable" "background" "check_shell" "chmod_enable" "chown_uploads" "chroot_list_enable" "chroot_local_user" "connect_from_port_20" "debug_ssl" "delete_failed_uploads" "deny_email_enable" "dirlist_enable" "dirmessage_enable" "download_enable" "dual_log_enable" "force_dot_files" "force_anon_data_ssl" "force_anon_logins_ssl" "force_local_data_ssl" "force_local_logins_ssl" "guest_enable" "hide_ids" "implicit_ssl" "listen" "listen_ipv6" "local_enable" "lock_upload_files" "log_ftp_protocol" "ls_recurse_enable" "mdtm_write" "no_anon_password" "no_log_lock" "one_process_model" "passwd_chroot_enable" "pasv_addr_resolve" "pasv_enable" "pasv_promiscuous" "port_enable" "port_promiscuous" "require_cert" "require_ssl_reuse" "run_as_launching_user" "secure_email_list_enable" "session_support" "setproctitle_enable" "ssl_enable" "ssl_request_cert" "ssl_sslv2" "ssl_sslv3" "ssl_tlsv1" "strict_ssl_read_eof" "strict_ssl_write_shutdown" "syslog_enable" "tcp_wrappers" "text_userdb_names" "tilde_user_enable" "use_localtime" "use_sendfile" "userlist_deny" "userlist_enable" "validate_cert" "virtual_use_local_privs" "write_enable" "xferlog_enable" "xferlog_std_format" "accept_timeout" "anon_max_rate" "anon_umask" "chown_upload_mode" "connect_timeout" "data_connection_timeout" "delay_failed_login" "delay_successful_login" "file_open_mode" "ftp_data_port" "idle_session_timeout" "listen_port" "local_max_rate" "local_umask" "max_clients" "max_login_fails" "max_per_ip" "pasv_max_port" "pasv_min_port" "trans_chunk_size" "anon_root" "banned_email_file" "banner_file" "ca_certs_file" "chown_username" "chroot_list_file" "cmds_allowed" "cmds_denied" "deny_file" "dsa_cert_file" "dsa_private_key_file" "email_password_file" "ftp_username" "ftpd_banner" "guest_username" "hide_file" "listen_address" "listen_address6" "local_root" "message_file" "nopriv_user" "pam_service_name" "pasv_address" "rsa_cert_file" "rsa_private_key_file" "secure_chroot_dir" "ssl_ciphers" "user_config_dir" "user_sub_token" "userlist_file" "vsftpd_log_file" "xferlog_file" )

  # About
  VSFTPD_VERSION=$(vsftpd -v | sed -e 's/[^0-9^.]/ /g' -e 's/^ *//g' -e 's/ *$//g')
  echo -e " _______________________________________________________________"
  echo -e "|\t\t\t\t\t\t\t\t|"
  echo -e "| # Service : VSFTPD (ftp)\t\t\t\t\t|"
  echo -e "| |--> author : Chris Evans\t\t\t\t\t|"
  echo -e "| |--> version : $VSFTPD_VERSION\t\t\t\t\t\t|"
  echo -e "| |--> url : https://security.appspot.com/vsftpd.html\t\t|"
  echo -e "|\t\t\t\t\t\t\t\t|"
  echo -e "| ------------------------------------------------------------- |"
  echo -e "|\t\t\t\t\t\t\t\t|"
  echo -e "| # Docker image : stefang/vsftpd\t\t\t\t|"
  echo -e "| |--> author : Stefan Gotkowski\t\t\t\t|"
  echo -e "| |--> version : $VERSION\t\t\t\t\t\t|"
  echo -e "| |--> url : https://github.com/StefanGotkowski/docker-vsftpd\t|"
  echo -e "|\t\t\t\t\t\t\t\t|"
  echo -e "| ------------------------------------------------------------- |"
  echo -e "|\t\t\t\t\t\t\t\t|"
  echo -e "| # License : GPLv2\t\t\t\t\t\t|"
  echo -e "|_______________________________________________________________|"
  echo ""

  # Copy config/user files
  cp /etc/vsftpd/vsftpd.conf -R -u -p /etc/vsftpd/configs/vsftpd.conf
  cp /etc/vsftpd/user_list -R -u -p /etc/vsftpd/configs/user_list


  # Function to change state/value of parameters in config files
  changeParam()
  {
    l=$(grep -n "$1=" /etc/vsftpd/configs/vsftpd.conf | head -n 1 | cut -d: -f1)
    if [ $l ]; then
      sed -i "${l}s{.*{$1=$2"{ /etc/vsftpd/configs/vsftpd.conf
      getMessageWithTime "|--> Set config [$1=$2]."
    else
      getMessageWithTime "|--> [ERROR]\tInvalid parameter [$1]."
    fi
  }

  getMessageWithTime "# Configuring settings of VSFTPD..."

  # First launch - basics
  changeParam background NO
  changeParam userlist_file /etc/vsftpd/configs.user_list

  # Change all configs
  for i in "${configs[@]}"
  do
    string=$i
    if typeset -p echo "$string" 2> /dev/null | grep -q '^'; then
      changeParam $string ${!string}
    fi
  done

  # Adding potential users
  set -- "$USERS"
  IFS=";"; declare -a allUsers=($*)
  IFS=""
  if [ $allUsers ]; then
    echo ""
    getMessageWithTime "# Adding user(s)..."

    for i in "${allUsers[@]}"
    do
      set -- "$i"
      IFS=":"; declare -a Array=($*)
      IFS=""
      adduser ${Array[0]}
      echo "${Array[0]}":"${Array[1]}" | chpasswd
      getMessageWithTime "|--> User [${Array[0]}] added with password [${Array[1]}]."
    done
  fi
fi

# Run service (and display errors)
echo ""
getMessageWithTime "# VSFTPD started"
vsftpdMessage=$( vsftpd /etc/vsftpd/configs/vsftpd.conf)
if [ ! -z "$vsftpdMessage" -a "$vsftpdMessage" != " " ]; then
  getMessageWithTime "|--> [ERROR]\t$vsftpdMessage"
fi
getMessageWithTime "# VSFTPD stoped"
