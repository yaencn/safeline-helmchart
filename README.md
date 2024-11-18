----helm package ------


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

------Installation Remind------

Warning: 

Any deployment resource in this HelmChart can only deploy one pod replica!

If multiple pod replicas are run, the entire WAF service will encounter unknown errors.

警告：

该HelmChart中的任何deployment资源清单只能部署一个pod副本!

如果运行多个pod副本，整个WAF服务将出现未知错误.

Acceleration address of GIT warehouse in Chinese Mainland:

GIT仓库在中国大陆的加速地址：

https://gitee.com/andyhau/safeline-helmchart.git

**Before version 6.1.2:**

在6.1.2版本之前，需要手动配置服务暴露方式，默认为NodePort方式。

These services must run on the same workload node in the k8s cluster:

这些服务必须运行在k8s集群中的同一个工作负载节点上。

```yaml
safeline-chaos, safeline-detector, safeline-tengine
```

It is recommended to use the nodeSelector setting.

建议使用nodeSelector进行设置。

**After version 6.1.2:**

在6.1.2版本之后，默认使用NodePort方式暴露服务。

default Expose Services As Ports mode.

默认使用NodePort方式暴露服务。

If you want to use the Ingress mode, you need to configure the `global.exposeServicesAsPorts.enabled` field in the values file to `false`.

如果你想使用Ingress方式，需要将values文件中的`global.exposeServicesAsPorts.enabled`字段设置为`false`。

Can be controlled by the value of the `global.exposeServicesAsPorts.enabled` field in the values file.

可以通过values文件中的`global.exposeServicesAsPorts.enabled`字段的值进行控制。

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

**After version 7.1.1:**

**7.1.1及以后的版本**

Added LTS long-term stable version and rolling update version switch. 
The LTS version is enabled by default. 
If you need to switch to the rolling update version, please set enabled to false.

新增LTS长期稳定版本与滚动更新版本开关，默认开启LTS版本，如需切换至滚动更新版本，请将enabled设置为false.

```yaml
  # 部署滚动更新版本与lts长期稳定版本的切换。如果需要切换至滚动更新版本，需将此项设置为false，该选项默认开启。
  global:
    ltsVersion:
      enabled: true
```
**Non TLS version deployment precautions**

**非TLS版部署注意事项**

When installing non LTS versions, `global.ltsVersion.enabled` must be set to `false`.

在安装非LTS版本时，必须将`global.ltsVersion.enabled`设置为`false`。


------HelmChart Install-----------

- HelmChart Web URL:
https://g-otkk6267.coding.net/public-artifacts/Charts/safeline/packages

- HelmChart Repo URL:
https://g-otkk6267-helm.pkg.coding.net/Charts/safeline

Sample：

helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline