<h4 align="center">
  SafeLine - Preview versions - HelmChart - Unofficial production
</h4>

<p align="center">
  <a target="_blank" href="https://waf-ce.chaitin.cn/">SafeLine Website</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-lts-helmchart">TLS Repository</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-helmchart">Preview Repository</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-helmchart/blob/master/README_CN.md">中文文档</a>
</p>

## ----- Readme -----

**Reminder:**

This branch is a preview version branch, which only contains preview versions.
To use LTS version, please visit the following GIT repository:
https://github.com/yaencn/safeline-lts-helmchart

- Preview Repository for github
https://github.com/yaencn/safeline-helmchart

Acceleration address of GIT warehouse in Chinese Mainland:

- Preview Repository
https://gitee.com/andyhau/safeline-helmchart.git

- LTS Repository
https://gitee.com/andyhau/safeline-lts-helmchart.git

## ----- HelmChart Install -----

- HelmChart Web URL:
https://g-otkk6267.coding.net/public-artifacts/Charts/safeline/packages

- HelmChart Repo URL:
https://g-otkk6267-helm.pkg.coding.net/Charts/safeline

- Sample：
```shell
# add repo
helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline
# install sample
helm install safeline --namespace safeline --set global.ingress.enabled=true --set global.ingress.hostname="waf.local"  safeline-lts/safeline-lts
# upgrade
helm -n safeline upgrade safeline safeline/safeline
# fetch chart
helm fetch --version 7.2.3 safeline/safeline
# uninstall
helm -n safeline uninstall safeline
```


## ----- Helm Build -----

```shell
# 检测helmchart-template是否有语法问题
cd safeline
helm template charts/ --output-dir ./result 
```

```shell
helm package ./safeline/charts/ -d ./assets/safeline

helm repo index --merge ./index.yaml --url assets assets/

rm -f ./index.yaml

mv ./assets/index.yaml ./index.yaml

cd ./assets/safeline/

helm coding-push safeline-${app-version}.tgz safeline
```

## ----- Installation Remind -----

**Warning:** 

Any deployment resource in this HelmChart can only deploy one pod replica!
If multiple pod replicas are run, the entire WAF service will encounter unknown errors.

## ----- Version Notes -----

**After version 6.1.2:**

- Default Expose Services As Ports mode
  - If you want to use the Ingress mode, you need to configure the `global.exposeServicesAsPorts.enabled` field in the values file to `false`.
  - Can be controlled by the value of the `global.exposeServicesAsPorts.enabled` field in the values file.

**After version 6.9.1:**

Add WAF console web interface to bind domain names through nginx-ingress.
Specifically participate in the values.yaml file.

```yaml
  # Set up the SafeLine WAF console to be accessed through a domain name.
  # For example: demowaf-ce.chaitin.cn
  global:
    ingress:
      # Whether to enable SafeLine WAF control for domain access.
      # It is not enabled by default
      enabled: true
      hostname: waf.local
      ingressClassName: nginx
      pathType: ImplementationSpecific
      path: /
      tls:
        # Whether to load the Secret of the HTTPS domain name certificate outside HelmChart. 
        #If yes, please fill in the Secret name. By default, it is not filled in and the domain name only enables http access.
        # If you fill in the following items, please create the corresponding Secret before running the HelmChart.
        secretName: "waf-xxx-com-tls"
```


## ----- Configuration Description -----
