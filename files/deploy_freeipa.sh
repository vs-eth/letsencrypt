#!/bin/bash
freeipa_deploy() {
  _cdomain="$1"
  _ckey="$2"
  _ccert="$3"
  _cca="$4"
  _cfullchain="$5"
  _info "Deploying certificate for FreeIPA Web UI"

  _debug _cdomain "$_cdomain"
  _debug _ckey "$_ckey"
  _debug _ccert "$_ccert"
  _debug _cca "$_cca"
  _debug _cfullchain "$_cfullchain"

  _cwd="${0%/*}/${_cdomain}"

  # delete old cert
  certutil -D -d "/etc/httpd/alias/" -n Server-Cert

  # add new cert
  certutil -A -d "/etc/httpd/alias/" -n Server-Cert -t u,u,u -i "$_ccert"

  openssl pkcs12 -export -out "${_cwd}/${_cdomain}.p12" -inkey "$_ckey" -in "$_ccert" -certfile "$_cca" -password pass:

  pk12util -i "${_cwd}/${_cdomain}.p12" -d "/etc/httpd/alias/" -k "/etc/httpd/alias/pwdfile.txt" -W ""

  systemctl start httpd
}

