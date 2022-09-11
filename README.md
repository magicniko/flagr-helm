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

## Contributing

  - if you change the chart, don't forget to bump its version number in `Chart.yaml`.
  - `ct` will only run for pull requests
  - make sure to add an example values file to `ci/` if you add a template
  - a new release is created only when a PR is merged to main, where the chart version was updated in `Chart.yaml`
