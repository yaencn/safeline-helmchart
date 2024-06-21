# Helm Chart for SafeLine

## Prerequisites

- Kubernetes cluster storage support RWX.

## Installation Remind

6.1.2 after：

These services must run on the same workload node in the k8s cluster:
safeline-chaos, safeline-detector, safeline-tengine
It is recommended to use the nodeSelector setting.

6.1.2 before:

default Expose Services As Ports mode.


## Installation

- HelmChart GitRepo URL:
https://g-otkk6267.coding.net/public/Charts/safeline-waf-helmchart/git

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
