<h4 align="center">
  SafeLine - 雷池 - 预览版本(非TLS) - HelmChart
</h4>

<p align="center">
  <a target="_blank" href="https://waf-ce.chaitin.cn/">雷池官方网站</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-lts-helmchart">TLS版GIT仓库</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-helmchart">预览版GIT仓库</a> &nbsp; | &nbsp;
  <a target="_blank" href="https://github.com/yaencn/safeline-helmchart/blob/master/README_CN.md">中文文档</a>
</p>

## ----- Readme -----

从AppVersion 7.5.0开始，为了更好的管理HelmChart版本，HelmChart Version将与AppVersion独立开始计算版本。

**提醒：**

此分支为预览版本分支，此分支中的仅包含预览版本。
如需使用LTS版本，请访问如下GIT仓库：
https://github.com/yaencn/safeline-helmchart

- Github的长期支持LTS版本仓库：
https://github.com/yaencn/safeline-lts-helmchart

GIT仓库在中国大陆的加速地址：
- 预览版仓库
https://gitee.com/andyhau/safeline-helmchart.git

- LTS版仓库
https://gitee.com/andyhau/safeline-lts-helmchart.git

- 国际版本部署支持
从appVersion为8.8.2开始支持x86_64架构的国际版部署支持，如需部署国际版本，请将value.yaml文件参数修改为如下值：
`global.image.registry=chaitin`
`global.image.region="-g"`

## ----- HelmChart Install -----

- HelmChart网页地址:
https://helm.yaencn.com

- HelmChart仓库地址:

此链接将在2025年9月1日起失效:

https://g-otkk6267-helm.pkg.coding.net/Charts/safeline

最新helmchart仓库地址：

https://helm.yaencn.com/charts


- 举例：
```shell
# 添加helm仓库
helm repo add yaencn https://helm.yaencn.com/charts

# 安装时定义postgresql的密码
helm install safeline ./safeline/charts \
  --namespace safeline \
  --create-namespace \
  --set database.internal.password="YourCustomPassWord"

# 安装中国大陆版本举例
helm install safeline --namespace safeline \
  --set global.ingress.enabled=true \
  --set global.ingress.hostname="waf.local" \
  yaencn/safeline

# 安装国际版本举例
helm install safeline --namespace safeline \
  --set global.ingress.enabled=true \
  --set global.ingress.hostname="waf.local" \
  --set global.image.registry=chaitin \
  --set global.image.region="-g" \
  yaencn/safeline

# 更新升级版本
helm -n safeline upgrade safeline yaencn/safeline
# 签出指定版本压缩包
helm fetch --version 10.0.9 yaencn/safeline
# 卸载服务
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

**警告：**

该HelmChart中的任何deployment资源清单只能部署一个pod副本!
如果运行多个pod副本，整个WAF服务将出现未知错误.

## ----- Version Notes -----

**6.1.2及以后的版本:**

- 默认使用NodePort方式暴露服务。
  - 如果你想使用Ingress方式，需要将values文件中的`global.exposeServicesAsPorts.enabled`字段设置为`false`。
  - 可以通过values文件中的`global.exposeServicesAsPorts.enabled`字段的值进行控制。

**6.9.1及以后的版本:**

增加WAF控制台web界面可通过nginx-ingress绑定域名,具体参加values.yaml文件

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
        # 是否加载HelmChart外部的HTTPS域名证书的Secret.
        # 如果有则请填写Secret名称，默认不填写及域名仅开启http访问.
        # 如填写如下项，请在运行该HelmChart前创建好对应的Secret。
        secretName: "waf-xxx-com-tls"
```


## ----- 核心配置参数 -----
| 参数 | 说明 | 默认值 |
|------|------|--------|
| `global.image.registry` | 镜像仓库地址 | `swr.cn-east-3.myhuaweicloud.com/chaitin-safeline` |
| `global.busyboxImage` | initContainer 基础镜像 | `busybox:1.36` |
| `global.exposeServicesAsPorts.enabled` | 以端口模式暴露服务（建议开启） | `true` |
| `global.env.DETECTOR_MGMT_AUTH` | 是否启用detector↔mgt管理API身份验证 ｜ `on` |
| `global.env.DETECTOR_MGMT_TOKEN` | detector ↔ MGT 管理API认证令牌 | `0443ca0668214f77156bc72fc35ec5822786cc8eaf3ac5fdfcf709922d8f6fb6` |
| `global.env.MGT_INTERNAL_TOKEN` | Tengine通知mgt用于重载配置的令牌 | `6dcce936a516e54f67caedcf47ad9fbb44f2aa04f6fad42e2b1cfbd22db1d568` |
| `global.env.DETECTOR_AES_KEY` | MGT和检测服务共享的16字节密钥,用于加密性能模式 | `gCXQqwwPIjpnvID3` |
| `global.env.DETECTOR_UPDATE_VERIFY` | 启用detector服务热更新验证 | `on` |
| `global.env.DETECTOR_UPDATE_PUBLIC_KEY` | Detector器服务热更新验证公钥 ｜ `""` |
| `global.env.RIVER_SELFCHECK` | 自查审计模式 ｜ `audit` |
| `global.env.RIVER_CN_CAPABILITY_GATE` | 能力门控制开关 | `off` |
| `global.env.RIVER_HEARTBEAT_EVIDENCE` | 心跳证据开关 | `off` |
| `global.env.luigi.ENTITLEMENT_CONSUMER_VERIFY` | Uigi服务权限消费验证开关 ｜ `off` |
| `global.env.chaos.ENTITLEMENT_CONSUMER_VERIFY` | Chaos服务权限消费验证开关 ｜ `off` |
| `database.internal.password` | 数据库密码（**建议修改**） | `changeit` |
| `database.type` | 数据库类型 `internal`/`external` | `internal` |
| `tengine.service.type` | tengine 服务类型 | `LoadBalancer` |
| `tengine.service.loadBalancerIP` | MetalLB 指定 IP | `""` |
| `mgt.service.type` | 管理控制台服务类型 | `NodePort` |
| `mgt.service.web.nodePort` | 管理控制台 NodePort 端口 | `31443` |
| `persistence.persistentVolumeClaim.*.storageClass` | 存储类 | `""` (使用默认) |

## 架构组件

| 组件 | 说明 | 端口 |
|------|------|------|
| **tengine** | WAF 反向代理引擎，处理入站流量 | 80, 65443, 9999 |
| **detector** | 威胁检测引擎，语义分析 | 8000, 8001, 7777 |
| **mgt** | 管理控制台 Web UI | 1443, 80, 8000 |
| **chaos** | 人机验证 / 等候室 | 9000, 23333, 8080 |
| **fvm** | 特征/漏洞管理 | 9004, 80 |
| **luigi** | 日志处理 | 80 |
| **database** | PostgreSQL 数据库 | 5432 |

## 安全注意事项

1.**环境量中的Token值**：建议在部署过程中修改`DETECTOR_MGMT_TOKEN`、`MGT_INTERNAL_TOKEN`和`DETECTOR_AES_KEY`变量的值。请参考`values.yaml`中的说明
2. **数据库密码**: 默认密码为 `changeit`，**建议**在部署前修改
3. **数据库连接串**: 已从 ConfigMap 迁移到 Secret 存储，避免明文泄露
4. **JWT 密钥**: `chaos-cm.yaml` 中包含默认 EC 私钥，生产环境建议替换：
   ```bash
   openssl ecparam -genkey -name prime256v1 -noout -out ec_private.pem
   openssl ec -in ec_private.pem -pubout -out ec_public.pem
   ```
5. **副本数限制**: 所有 Deployment 只能运行 **1 个副本**，多副本会导致 WAF 服务异常



