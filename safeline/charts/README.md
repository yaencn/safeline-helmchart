# Helm Chart for SafeLine

Starting from AppVersion 7.5.0, in order to better manage HelmChart versions, HelmChart Version will be calculated independently from AppVersion

## Prerequisites

- Kubernetes cluster storage support RWX.

## Installation

- HelmChart GitRepo URL:
https://github.com/yaencn/safeline-helmchart.git

https://gitee.com/andyhau/safeline-helmchart.git

- HelmChart Web URL:
https://helm.yaencn.com/

- HelmChart Repo URL:

https://helm.yaencn.com/charts

- Install the SafeLine helm chart with a release name `safeline`:
```bash
# add repo
helm repo add yaencn https://helm.yaencn.com/charts
# install sample
helm install safeline --namespace safeline --set global.ingress.enabled=true --set global.ingress.hostname="waf.local"  yaencn/safeline
# upgrade
helm -n safeline upgrade safeline yaencn/safeline
# fetch chart
helm fetch --version 10.0.19 yaencn/safeline
# uninstall
helm -n safeline uninstall safeline
```

## Uninstallation

To uninstall/delete the `safeline` deployment:
```bash
helm -n safeline uninstall safeline
```

## Installation Remind

Reminder:

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

- International version deployment support
International version deployment support for the x86_64 architecture is supported starting from appVersion 8.8.2. If you need to deploy the international version, please modify the value.yaml file parameters to the following values:
`global.image.registry=chaitin`
`global.image.region="-g"`

**提醒：**

此分支为预览版本分支，此分支中的仅包含预览版本。
如需使用LTS版本，请访问如下GIT仓库：
https://github.com/yaencn/safeline-helmchart

GIT仓库在中国大陆的加速地址：
- 预览版仓库
https://gitee.com/andyhau/safeline-helmchart.git

- LTS版仓库
https://gitee.com/andyhau/safeline-lts-helmchart.git


- 国际版本部署支持
从appVersion为8.8.2开始支持x86_64架构的国际版部署支持，如需部署国际版本，请将value.yaml文件参数修改为如下值：
`global.image.registry=chaitin`
`global.image.region="-g"`

------Installation Remind------

**Warning:** 

Any deployment resource in this HelmChart can only deploy one pod replica!
If multiple pod replicas are run, the entire WAF service will encounter unknown errors.
Acceleration address of GIT warehouse in Chinese Mainland:

**警告：**

该HelmChart中的任何deployment资源清单只能部署一个pod副本!
如果运行多个pod副本，整个WAF服务将出现未知错误.

## Version Notes

**After version 6.9.1:**

Add WAF console web interface to bind domain names through nginx-ingress.

Specifically participate in the values.yaml file.

增加WAF控制台web界面可通过nginx-ingress绑定域名,具体参加values.yaml文件。

```yaml
  # 设置雷池WAF控制台通过域名访问，如：demo.waf-ce.chaitin.cn
  global:
    ingress:
      # 是否开启雷池WAF控制通过域名访问，默认未开启
      enabled: true
      hostname: waf.local
      ingressClassName: nginx
      pathType: ImplementationSpecific
      path: /
      tls:
        # 是否加载HelmChart外部的HTTPS域名证书Secret,如果有请填写Secret名称，默认不填写及域名仅开启http访问.
        # 如填写如下项，请在运行该HelmChart前创建好对应的Secret。
        secretName: "waf-xxx-com-tls"
```
