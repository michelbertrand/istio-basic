
#/bin/bash

echo '##################################################################################################'
echo ' Details service '
echo '##################################################################################################'

helm template details /home/michel/workspace-devops/istio-basic \
    --set namespace=bookinfo \
    --set labels.app=details \
    --set labels.version=v1 \
    --set selectorLabels.app=details \
    --set selectorLabels.version=v1 \
    --set podLabels.app=details \
    --set podLabels.version=v1 \
    --set nameOverride=details \
    --set fullnameOverride=details-v1 \
    --set image.tag=1.20.3 \
    --set image.repository=docker.io/istio/examples-bookinfo-details-v1 \
    --set image.PullPolicy=IfNotPresent \
    --set envoyFilter.create=true \
    --set service.port=9080 \
    --set service.type=ClusterIP \
    --set service.labels.app=details \
    --set service.labels.service=details \
    --set serviceAccount.name=bookinfo-details \
    --set serviceAccount.annotations."account"=details

helm install details /home/michel/workspace-devops/istio-basic \
    --set namespace=bookinfo \
    --set labels.app=details \
    --set labels.version=v1 \
    --set selectorLabels.app=details \
    --set selectorLabels.version=v1 \
    --set podLabels.app=details \
    --set podLabels.version=v1 \
    --set nameOverride=details \
    --set fullnameOverride=details-v1 \
    --set image.tag=1.20.3 \
    --set image.repository=docker.io/istio/examples-bookinfo-details-v1 \
    --set image.PullPolicy=IfNotPresent \
    --set envoyFilter.create=true \
    --set service.port=9080 \
    --set service.type=ClusterIP \
    --set service.labels.app=details \
    --set service.labels.service=details \
    --set serviceAccount.name=bookinfo-details \
    --set serviceAccount.annotations."account"=details

echo '##################################################################################################'
echo ' Ratings service '
echo '##################################################################################################'

helm template ratings /home/michel/workspace-devops/istio-basic \
  --set labels.app=ratings \
  --set labels.version=v1 \
  --set nameOverride=ratings \
  --set fullnameOverride=ratings-v1 \
  --set selectorLabels.app=ratings \
  --set selectorLabels.version=v1 \
  --set podLabels.app=ratings \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-ratings-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=ratings \
  --set service.labels.service=ratings \
  --set serviceAccount.name=bookinfo-ratings \
  --set serviceAccount.annotations."account"=ratings

helm install ratings /home/michel/workspace-devops/istio-basic \
  --set labels.app=ratings \
  --set labels.version=v1 \
  --set nameOverride=ratings \
  --set fullnameOverride=ratings-v1 \
  --set selectorLabels.app=ratings \
  --set selectorLabels.version=v1 \
  --set podLabels.app=ratings \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-ratings-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=ratings \
  --set service.labels.service=ratings \
  --set serviceAccount.name=bookinfo-ratings \
  --set serviceAccount.annotations."account"=ratings

echo '##################################################################################################'
echo ' Reviews service '
echo '##################################################################################################'

helm template reviews /home/michel/workspace-devops/istio-basic \
  --set labels.app=reviews \
  --set labels.version=v1 \
  --set nameOverride=reviews \
  --set fullnameOverride=reviews-v1 \
  --set selectorLabels.app=reviews \
  --set selectorLabels.version=v1 \
  --set podLabels.app=reviews \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-reviews-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=wlp-output' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumes[1].name=tmp' \
  --set 'volumes[1].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set 'volumeMounts[1].name=wlp-output' \
  --set 'volumeMounts[1].mountPath=/opt/ibm/wlp/output' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=reviews \
  --set service.labels.service=reviews \
  --set serviceAccount.name=bookinfo-reviews \
  --set serviceAccount.annotations."account"=reviews

helm install reviews /home/michel/workspace-devops/istio-basic \
  --set labels.app=reviews \
  --set labels.version=v1 \
  --set nameOverride=reviews \
  --set fullnameOverride=reviews-v1 \
  --set selectorLabels.app=reviews \
  --set selectorLabels.version=v1 \
  --set podLabels.app=reviews \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-reviews-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=wlp-output' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumes[1].name=tmp' \
  --set 'volumes[1].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set 'volumeMounts[1].name=wlp-output' \
  --set 'volumeMounts[1].mountPath=/opt/ibm/wlp/output' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=reviews \
  --set service.labels.service=reviews \
  --set serviceAccount.name=bookinfo-reviews \
  --set serviceAccount.annotations."account"=reviews

echo '##################################################################################################'
echo ' Reviews V2 service '
echo '##################################################################################################'

helm template reviews-v2 /home/michel/workspace-devops/istio-basic \
  --set labels.app=reviews \
  --set labels.version=v2 \
  --set nameOverride=reviews \
  --set fullnameOverride=reviews-v2 \
  --set selectorLabels.app=reviews \
  --set selectorLabels.version=v2 \
  --set podLabels.app=reviews \
  --set podLabels.version=v2 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-reviews-v2 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=wlp-output' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumes[1].name=tmp' \
  --set 'volumes[1].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set 'volumeMounts[1].name=wlp-output' \
  --set 'volumeMounts[1].mountPath=/opt/ibm/wlp/output' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=reviews \
  --set service.labels.service=reviews \
  --set service.create=false \
  --set serviceAccount.create=false 
  
helm install reviews-v2 /home/michel/workspace-devops/istio-basic \
  --set labels.app=reviews \
  --set labels.version=v2 \
  --set nameOverride=reviews \
  --set fullnameOverride=reviews-v2 \
  --set selectorLabels.app=reviews \
  --set selectorLabels.version=v2 \
  --set podLabels.app=reviews \
  --set podLabels.version=v2 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-reviews-v2 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=wlp-output' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumes[1].name=tmp' \
  --set 'volumes[1].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set 'volumeMounts[1].name=wlp-output' \
  --set 'volumeMounts[1].mountPath=/opt/ibm/wlp/output' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=reviews \
  --set service.labels.service=reviews \
  --set service.create=false \
  --set serviceAccount.create=false

echo '##################################################################################################'
echo ' Reviews V3 service '
echo '##################################################################################################'  

helm template reviews-v3 /home/michel/workspace-devops/istio-basic \
  --set labels.app=reviews \
  --set labels.version=v3 \
  --set nameOverride=reviews \
  --set fullnameOverride=reviews-v3 \
  --set selectorLabels.app=reviews \
  --set selectorLabels.version=v3 \
  --set podLabels.app=reviews \
  --set podLabels.version=v3 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-reviews-v3 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=wlp-output' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumes[1].name=tmp' \
  --set 'volumes[1].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set 'volumeMounts[1].name=wlp-output' \
  --set 'volumeMounts[1].mountPath=/opt/ibm/wlp/output' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=reviews \
  --set service.labels.service=reviews \
  --set service.create=false \
  --set serviceAccount.create=false 

helm install reviews-v3 /home/michel/workspace-devops/istio-basic \
  --set labels.app=reviews \
  --set labels.version=v3 \
  --set nameOverride=reviews \
  --set fullnameOverride=reviews-v3 \
  --set selectorLabels.app=reviews \
  --set selectorLabels.version=v3 \
  --set podLabels.app=reviews \
  --set podLabels.version=v3 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-reviews-v3 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=wlp-output' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumes[1].name=tmp' \
  --set 'volumes[1].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set 'volumeMounts[1].name=wlp-output' \
  --set 'volumeMounts[1].mountPath=/opt/ibm/wlp/output' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=reviews \
  --set service.labels.service=reviews \
  --set service.create=false \
  --set serviceAccount.create=false 


echo '##################################################################################################'
echo ' Productpage services '
echo '##################################################################################################'  

helm template productpage /home/michel/workspace-devops/istio-basic \
  --set labels.app=productpage \
  --set labels.version=v3 \
  --set nameOverride=productpage \
  --set fullnameOverride=productpage-v1 \
  --set selectorLabels.app=productpage \
  --set selectorLabels.version=v1 \
  --set podAnnotations."prometheus.io/scrape"="true" \
  --set podAnnotations."prometheus.io/port"="9080" \
  --set podAnnotations."prometheus.io/path"="/metrics" \
  --set podLabels.app=productpage \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-productpage-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=tmp' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=productpage \
  --set service.labels.service=productpage \
  --set serviceAccount.name=bookinfo-productpage \
  --set serviceAccount.annotations."account"=productpage 

  helm install productpage /home/michel/workspace-devops/istio-basic \
  --set labels.app=productpage \
  --set labels.version=v3 \
  --set nameOverride=productpage \
  --set fullnameOverride=productpage-v1 \
  --set selectorLabels.app=productpage \
  --set selectorLabels.version=v1 \
  --set podAnnotations."prometheus.io/scrape"="true" \
  --set podAnnotations."prometheus.io/port"="9080" \
  --set podAnnotations."prometheus.io/path"="/metrics" \
  --set podLabels.app=productpage \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-productpage-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set envoyFilter.create=false \
  --set 'volumes[0].name=tmp' \
  --set 'volumes[0].emptyDir=null' \
  --set 'volumeMounts[0].name=tmp' \
  --set 'volumeMounts[0].mountPath=/tmp' \
  --set service.port=9080 \
  --set service.type=ClusterIP \
  --set service.labels.app=productpage \
  --set service.labels.service=productpage \
  --set serviceAccount.name=bookinfo-productpage \
  --set serviceAccount.annotations."account"=productpage 

  

