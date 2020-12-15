echo '
server {
  listen 127.0.0.1:65510;
  include /etc/nginx/conf.d/listen_plain.active;
  include /etc/nginx/conf.d/listen_ssl.active;

  ssl_certificate /etc/ssl/mail/cert.pem;
  ssl_certificate_key /etc/ssl/mail/key.pem;

  include /etc/nginx/conf.d/server_name.active;

  include /etc/nginx/conf.d/includes/site-defaults.conf;
}

server {
        listen 80;
        listen [::]:80;

        server_name  betaclient.'${MAILCOW_HOSTNAME}';

        location ^~ / {
          proxy_pass       http://frontend:80;
          proxy_set_header Host      $http_host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_redirect off;
        }
        
        location ^~ /app/ {
          proxy_pass       http://backend:8090/;
          proxy_set_header Host      $http_host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_redirect off;
        }
}
';
for cert_dir in /etc/ssl/mail/*/ ; do
  if [[ ! -f ${cert_dir}domains ]] || [[ ! -f ${cert_dir}cert.pem ]] || [[ ! -f ${cert_dir}key.pem ]]; then
    continue
  fi
  # do not create vhost for default-certificate. the cert is already in the default server listen
  domains="$(cat ${cert_dir}domains | sed -e 's/^[[:space:]]*//')"
  case "${domains}" in
    "") continue;;
    "${MAILCOW_HOSTNAME}"*) continue;;
  esac
  echo -n '
server {
  include /etc/nginx/conf.d/listen_ssl.active;

  ssl_certificate '${cert_dir}'cert.pem;
  ssl_certificate_key '${cert_dir}'key.pem;
';
  echo -n '
  server_name '${domains}';

  include /etc/nginx/conf.d/includes/site-defaults.conf;
}
';
done
