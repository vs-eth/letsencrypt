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

  # Start Apache again since ipa-certupdate does JSON requests
  systemctl start httpd

  ipa-cacert-manage install "${_cwd}/isrgrootx1.cer" -n ISRGRootX1 -t C,,
  ipa-certupdate
  ipa-cacert-manage install "${_cwd}/DSTRootCAX3.cer" -n DSTRootCAX3 -t C,,
  ipa-certupdate
  ipa-cacert-manage install "${_cwd}/LetsEncryptAuthorityX3.cer" -n LetsEncryptX3 -t C,,
  ipa-certupdate
  ipa-cacert-manage install "${_cwd}/LetsEncryptAuthorityX4.cer" -n LetsEncryptX4 -t C,,
  ipa-certupdate

  ipa-server-certinstall -d -w "$_ckey" "$_ccert" --dirman-password=${DIRMAN_PASSWORD} --pin=

  systemctl restart httpd
  systemctl restart dirsrv@${DIRSRV_INSTANCE}.service
}

