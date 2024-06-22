# Role: letsencrypt

Role to setup Let's Encrypt certificates

## Configuration
|Variable|Default value|Description|
|--------|-------------|-----------|
|letsencrypt_domain|`{{ ansible_fqdn }}`|Primary domain to get certificate for|
|letsencrypt_domain_extra|`[]`|List of extra domains to get certificate for|
|letsencrypt_port|"80"|Port for webserver to listen on (if using standalone mode)|
|letsencrypt_base_dir|`/root/.acme.sh`|Directory to install the acme.sh client to|
|letsencrypt_staging|`True`|Whether to use the staging CA|
|letsencrypt_issue_mode|`webroot`| Whether to use `webroot` or `standalone` mode (see below)|
|letsencrypt_install_mode|`install`| Whether to `install` or `deploy` the certificate |
|letsencrypt_webroot|`/var/www/letsencrypt`|The directory to use as webroot (if using webroot mode)|
|letsencrypt_ecc|`false`|Whether to use the ecc-cert when installing, deploying|
|letsencrypt_issue|empty|Pre/post/renew commands for certificate issurance|
|letsencrypt_install|see defaults/main.yml|Where to install the certificate to (if installing)|
|letsencrypt_reloadcmd|Empty|Command to execute after installing new certificates (if installing)|
|letsencrypt_deploy|Empty|Hooks to use (if using deploy mode)|
|letsencrypt_force|`False`|Force-renew certificate. Useful when switching from staging to production|
|letsencrypt_default_ca|`letsencrypt`|Default CA that will be used to issue the certificate. May be changed to e.g. `zerossl` to avoid rate limits but requires registration|

### Issurance modes
For certificate issurance, this role supports a "standalone" mode, where a
webserver will be started and a "webroot" mode where the webserver is already
expected to be running. An example webroot configuration for NGINX might look
like this:
```
server {
    listen       [::]:80 ipv6only=off default_server;
    server_name  {{ ansible_fqdn }};

    location ^~ /.well-known/acme-challenge {
        default_type text/plain;
        alias {{ letsencrypt_webroot }}/.well-known/acme-challenge;
    }
    ...
}
```

### Install modes
Certificates can either be "installed", that is, copied to some location and
optionally executing a "reload" command or "deployed". Deployment means that
special care is required, this repository includes deploy scripts for
ejabberd, freeipa and our mailserver role. Have a look at the respective shell
file in `files` for pointers.

## License
GPLv3, except for the Let's Encrypt CA roots in `files`, which are, as far as
we understand, in the public domain.
