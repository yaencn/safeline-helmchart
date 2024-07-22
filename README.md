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

Before version 6.1.2:

These services must run on the same workload node in the k8s cluster:

safeline-chaos, safeline-detector, safeline-tengine

It is recommended to use the nodeSelector setting.

After version 6.1.2:

default Expose Services As Ports mode.

Can be controlled by the value of the `global.exposeServicesAsPorts.enabled` field in the values file.

------HelmChart Install-----------

- HelmChart Web URL:
https://g-otkk6267.coding.net/public-artifacts/Charts/safeline/packages
- HelmChart Repo URL:
https://g-otkk6267-helm.pkg.coding.net/Charts/safeline

Sample：

helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline