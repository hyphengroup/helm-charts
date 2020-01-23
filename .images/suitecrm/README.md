## SuiteCRM

Dockerfile for SuiteCRM 7.11.10 on php 7.3 / debian buster

- Configures Php to store sessions in Redis
- Uses sourceforge release archive to set up SuiteCRM without having to run `composer install --no-dev`
- Runs SuiteCRM silent install as part of entrypoint (could define `/bootstrap/` as a volume to control this?)
- Runs cron process in background without supervisord (there's a risk cron stops running?)
- Includes procps / mysql-client for basic utilities (dump db / restore db)

Notes:

- got "warning already loaded ..." for: curl / mysqli / mbstring ...
- Need to add https://github.com/Lusitaniae/apache_exporter see https://sourcegraph.com/github.com/bitnami/charts/-/blob/upstreamed/suitecrm/templates/deployment.yaml#L129
