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

  cat $_ckey $_ccert $_cca > $_target
  chown ejabberd:ejabberd $_target
  chmod 640 $_target

  systemctl restart ejabberd
}
