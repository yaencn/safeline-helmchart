----helm package ------

helm package ./safeline/5.6.0/ -d ./assets/safeline

helm repo index --merge ./index.yaml --url assets assets/

rm -f ./index.yaml

mv ./assets/index.yaml ./index.yaml

cd ./assets/safeline/
helm coding-push safeline-5.6.0.tgz safeline