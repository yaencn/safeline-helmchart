# Helm Chart for SafeLine

## Prerequisites

- Kubernetes cluster storage support RWX.

## Installation

- HelmChart GitRepo URL:
https://e.coding.net/g-otkk6267/Charts/safeline-waf-helmchart.git

- HelmChart Web URL:
https://g-otkk6267.coding.net/public-artifacts/Charts/safeline/packages

- HelmChart Repo URL:
https://g-otkk6267-helm.pkg.coding.net/Charts/safeline

- Install the SafeLine helm chart with a release name `safeline`:
```bash
helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline
helm -n safeline upgrade safeline safeline/safeline
```

## Uninstallation

To uninstall/delete the `safeline` deployment:
```bash
helm -n safeline uninstall safeline
```
