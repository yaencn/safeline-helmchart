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
| `global.env.DETECTOR_MGMT_AUTH` | Whether to enable detector↔mgt management API authentication ｜ `on` |
| `global.env.DETECTOR_MGMT_TOKEN` | detector ↔ MGT Management API Authentication Token | `0443ca0668214f77156bc72fc35ec5822786cc8eaf3ac5fdfcf709922d8f6fb6` |
| `global.env.MGT_INTERNAL_TOKEN` | Tengine notifies mgt of the token used for overloading configuration | `6dcce936a516e54f67caedcf47ad9fbb44f2aa04f6fad42e2b1cfbd22db1d568` |
| `global.env.DETECTOR_AES_KEY` | The 16 byte key shared by MGT and detect services is used to encrypt performance mode | `gCXQqwwPIjpnvID3` |
| `global.env.DETECTOR_UPDATE_VERIFY` | Enable Detector service hot update verification | `on` |
| `global.env.DETECTOR_UPDATE_PUBLIC_KEY` | Detector service hot update verification public key ｜ `""` |
| `global.env.RIVER_SELFCHECK` | River self inspection audit mode ｜ `audit` |
| `global.env.RIVER_CN_CAPABILITY_GATE` | Ability Gate Control Switch | `off` |
| `global.env.RIVER_HEARTBEAT_EVIDENCE` | River heartbeat evidence switch | `off` |
| `global.env.luigi.ENTITLEMENT_CONSUMER_VERIFY` | Uigi Service Rights Consumption Verification Switch ｜ `off` |
| `global.env.chaos.ENTITLEMENT_CONSUMER_VERIFY` | Chaos Service Rights Consumption Verification Switch ｜ `off` |
| `database.internal.password` | Database password (**recommended to change**) | `changeit` |
| `database.type` | Database type `internal`/`external` | `internal` |
| `tengine.service.type` | Tengine service type | `LoadBalancer` |
| `tengine.service.loadBalancerIP` | MetalLB specified IP | `""` |
| `mgt.service.type` | Management console service type | `NodePort` |
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

1. **Token value in environmental quantity**: It is recommended to modify the values of the DETECTOR_MGMT_TOKEN, MGT_INTERNAL_TOKEN, and DETECTOR_AES_KEY variables during deployment. Please refer to the instructions in the `values.yaml` file for details.
3. **Database Password**: The default password is `changeit`, **recommended** to be changed before deployment.
3. **Database Connection String**: Migrated from ConfigMap to Secret storage to avoid plaintext leakage.
4. **JWT Key**: The default EC private key is included in `chaos-cm.yaml`, it is recommended to replace it in production environments:
```bash
openssl ecparam -genkey -name prime256v1 -noout -out ec_private.pem
openssl ec -in ec_private.pem -pubout -out ec_public.pem
```
5. **Replica Limit**: All Deployments can only run... **Only one replica is needed.** Multiple replicas will cause WAF service malfunctions.
