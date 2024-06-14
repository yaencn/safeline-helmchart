----helm package ------

helm package ./safeline/charts/ -d ./assets/safeline

helm repo index --merge ./index.yaml --url assets assets/

rm -f ./index.yaml

mv ./assets/index.yaml ./index.yaml

cd ./assets/safeline/
helm coding-push safeline-<app-version>.tgz safeline

------Installation Remind------
These services must run on the same workload node in the k8s cluster:
safeline-chaos, safeline-detector, safeline-tengine
It is recommended to use the nodeSelector setting.

------HelmChart Install-----------
- HelmChart Web URL:
https://g-otkk6267.coding.net/public-artifacts/Charts/safeline/packages
- HelmChart Repo URL:
https://g-otkk6267-helm.pkg.coding.net/Charts/safeline
Sample：
helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline