#!/bin/bash

ejabberd_deploy() {
  _cdomain="$1"
  _ckey="$2"
  _ccert="$3"
  _cca="$4"
  _cfullchain="$5"
  _info "Deploying certificate for Ejabberd"
  
  _target="/etc/ejabberd/ejabberd.pem"

  _debug _cdomain "$_cdomain"
  _debug _ckey "$_ckey"
  _debug _ccert "$_ccert"
  _debug _cca "$_cca"
  _debug _cfullchain "$_cfullchain"

  _cwd="${0%/*}/${_cdomain}"

  # Ejabberds special magic file
  cat $_ckey $_ccert $_cca > $_target
  chown ejabberd:ejabberd $_target
  chmod 640 $_target

  systemctl restart ejabberd
  
  # We also have nginx, mainly for serving the verification as standalone mode makes it impossible to use sshfs
  cp $_ckey /etc/nginx/certs/sosxmpp.ethz.ch/privkey.pem
  cat $_ccert $_cca > /etc/nginx/certs/sosxmpp.ethz.ch/fullchain.pem
  chown -R root:nginx /etc/nginx/certs/sosxmpp.ethz.ch
  chmod -R 640 /etc/nginx/certs/sosxmpp.ethz.ch
  
  systemctl restart nginx
}
