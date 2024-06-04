----helm package ------

helm package ./safeline/6.0.0/ -d ./assets/safeline

helm repo index --merge ./index.yaml --url assets assets/

rm -f ./index.yaml

mv ./assets/index.yaml ./index.yaml

cd ./assets/safeline/
helm coding-push safeline-6.0.0.tgz safeline

------HelmChart Install-----------
- HelmChart Web URL:
https://g-otkk6267.coding.net/public-artifacts/Charts/safeline/packages
- HelmChart Repo URL:
https://g-otkk6267-helm.pkg.coding.net/Charts/safeline
Sample：
helm repo add safeline https://g-otkk6267-helm.pkg.coding.net/Charts/safeline