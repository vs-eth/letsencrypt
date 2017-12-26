#!/bin/bash

mailserver_deploy() {
  _cdomain="$1"
  _ckey="$2"
  _ccert="$3"
  _cca="$4"
  _cfullchain="$5"
  _info "Deploying certificate for a mail server"
  
  _target="/etc/postfix/server.pem"
  _target_key="/etc/postfix/server.key"
  _client="/etc/postfix/client.pem"
  _client_key="/etc/postfix/client.key"

  _debug _cdomain "$_cdomain"
  _debug _ckey "$_ckey"
  _debug _ccert "$_ccert"
  _debug _cca "$_cca"
  _debug _cfullchain "$_cfullchain"

  _cwd="${0%/*}/${_cdomain}"

  # Copy certificates to where postfix and dovecot expect them
  cp $_cfullchain $_target
  cp $_ckey $_target_key
  chown root:postfix $_target
  chown root:postfix $_target_key
  chmod 640 $_target
  chmod 640 $_target_key
  
  # For letsencrypt, we usually have:
  # X509v3 Extended Key Usage: TLS Web Server Authentication, TLS Web Client Authentication
  # I don't know why they do this, but in this case we can also use it as a client cert
  cp $_ccert $_client
  cp $_ckey $_client_key
  chown root:postfix $_client
  chown root:postfix $_client_key
  chmod 640 $_client
  chmod 640 $_client_key
  
  systemctl restart postfix
  systemctl restart dovecot
  
  # We also have nginx, mainly for serving the verification as standalone mode makes it impossible to use sshfs
  cp $_ckey /etc/nginx/certs/$domain/privkey.pem
  cat $_ccert $_cca > /etc/nginx/certs/$domain/fullchain.pem
  chown -R root:root /etc/nginx/certs/$domain
  chmod -R 640 /etc/nginx/certs/$domain
  
  systemctl restart nginx
}
