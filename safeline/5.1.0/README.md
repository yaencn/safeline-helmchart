# Helm Chart for SafeLine

## Prerequisites

- Kubernetes cluster storage support RWX.

## Installation

Install the SafeLine helm chart with a release name `safeline`:
```bash
helm repo add jangrui https://gitlab.healthych.com/charts/safeline-waf-chart
helm -n safeline upgrade -i safeline charts/safeline-waf-chart --create-namespace
```

## Uninstallation

To uninstall/delete the `safeline` deployment:
```bash
helm -n safeline uninstall safeline
```
