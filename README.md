# Flagr Helm Chart

A helm chart for flagr with support for:

  * datadog APM, APPSEC and other such things
  * cloudflared tunnel for the admin interface
  * horizontal pod autoscaler
  * ExternalSecrets Operator

## Usage

Add the helm repo:

```
helm repo add flagr https://magicniko.github.io/flagr-helm/
```

Basic usage:

```
helm upgrade --install flagr --namespace flagr --create-namespace flagr/flagr
```

## Production Advice

  * use external secrets or something secure like that
  * set a basic auth password just in case other security measures fail
  * use a database such as postgres for persistence
  * use cloudflared to protect the admin interface, or set the ingress path to `/`
