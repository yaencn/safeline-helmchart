<h4 align="center">
  SafeLine - Preview Versions - HelmChart
</h4>

<p align="center">
  <a target="_blank" href="https://waf-ce.chaitin.cn/">SafeLine Website</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-lts-helmchart">TLS Repository</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-helmchart">Preview Repository</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-helmchart/blob/master/README_CN.md">中文文档</a>
</p>

## ----- Readme -----

Starting from AppVersion 7.5.0, in order to better manage HelmChart versions, HelmChart Version will be calculated independently from AppVersion.

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

- International version deployment support
International version deployment support for the x86_64 architecture is supported starting from appVersion 8.8.2. If you need to deploy the international version, please modify the value.yaml file parameters to the following values:
`global.image.registry=chaitin`
`global.image.region="-g"`

## ----- HelmChart Install -----

- HelmChart Web URL:
https://helm.yaencn.com

- HelmChart Repo URL:

This link will expire on September 1, 2025:

https://g-otkk6267-helm.pkg.coding.net/Charts/safeline

The latest helmchart warehouse address:

https://helm.yaencn.com/charts

- Sample：
```shell
# add repo
helm repo add yaencn https://helm.yaencn.com/charts

# Custom PostgreSQL password
helm install safeline ./safeline/charts \
  --namespace safeline \
  --create-namespace \
  --set database.internal.password="YourCustomPassWord"

# install sample
helm install safeline --namespace safeline \
  --set global.ingress.enabled=true \
  --set global.ingress.hostname="waf.local" \
  yaencn/safeline

# install the International version
helm install safeline --namespace safeline \
  --set global.ingress.enabled=true \
  --set global.ingress.hostname="waf.local" \
  --set global.image.registry=chaitin \
  --set global.image.region="-g" \
  yaencn/safeline

# upgrade
helm -n safeline upgrade safeline yaencn/safeline
# fetch chart
helm fetch --version 10.0.9 yaencn/safeline
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


## ----- Core Configuration Parameters -----

| Parameter | Description | Default Value |
|------|------|--------|
| `global.image.registry` | Image repository address | `swr.cn-east-3.myhuaweicloud.com/chaitin-safeline` |
| `global.busyboxImage` | InitContainer base image | `busybox:1.36` |
| `global.exposeServicesAsPorts.enabled` | Expose services in port mode (recommended to enable) | `true` |
| `database.internal.password` | Database password (**recommended to change**) | `changeit` |
| `database.type` | Database type `internal`/`external` | `internal` |
| `tengine.service.type` | Tengine service type | `LoadBalancer` |
| `tengine.service.loadBalancerIP` | MetalLB specified IP | `""` | | `mgt.service.type` | Management console service type | `NodePort` |
| `mgt.service.web.nodePort` | Management console NodePort | `31443` |
| `persistence.persistentVolumeClaim.*.storageClass` | Storage class | `""` (use default) |

## Architecture Components

| Component | Description | Port |
|------|------|------|
| **tengine** | WAF reverse proxy engine, handles inbound traffic | 80, 65443, 9999 |
| **detector** | Threat detection engine, semantic analysis | 8000, 8001, 7777 |
| **mgt** | Management console Web UI | 1443, 80, 8000 |
| **chaos** | Human verification / waiting room | 9000, 23333, 8080 |
| **fvm** | Feature/Vulnerability Management | 9004, 80 |
| **luigi** | Log Processing | 80 |
| **database** | PostgreSQL Database | 5432 |

## Security Considerations

1. **Database Password**: The default password is `changeit`, **recommended** to be changed before deployment.
2. **Database Connection String**: Migrated from ConfigMap to Secret storage to avoid plaintext leakage.
3. **JWT Key**: The default EC private key is included in `chaos-cm.yaml`, it is recommended to replace it in production environments:
``bash
openssl ecparam -genkey -name prime256v1 -noout -out ec_private.pem
openssl ec -in ec_private.pem -pubout -out ec_public.pem
```
4. **Replica Limit**: All Deployments can only run... **Only one replica is needed.** Multiple replicas will cause WAF service malfunctions.
