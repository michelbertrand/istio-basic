
#/bin/bash

echo '##################################################################################################'
echo ' Details service '
echo '##################################################################################################'

helm template details /home/michel/workspace-devops/istio-basic \
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
    --set service.port=9080 \
    --set service.type=LoadBalancer \
    --set service.labels.app=details \
    --set service.labels.service=details \
    --set serviceAccount.name=bookinfo-details \
    --set serviceAccount.annotations."account"=details

helm install details /home/michel/workspace-devops/istio-basic \
  --set labels.app=details \
  --set labels.version=v1 \
  --set nameOverride=details \
  --set fullnameOverride=details-v1 \
  --set selectorLabels.app=details \
  --set selectorLabels.version=v1 \
  --set podLabels.app=details \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-details-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set service.port=9080 \
  --set service.type=LoadBalancer \
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
  --set service.port=9080 \
  --set service.type=LoadBalancer \
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
  --set podLabels.app=details \
  --set podLabels.version=v1 \
  --set image.tag=1.20.3 \
  --set image.repository=docker.io/istio/examples-bookinfo-ratings-v1 \
  --set image.PullPolicy=IfNotPresent \
  --set service.port=9080 \
  --set service.type=LoadBalancer \
  --set service.labels.app=ratings \
  --set service.labels.service=ratings \  
  --set serviceAccount.name=bookinfo-ratings \
  --set serviceAccount.annotations."account"=ratings





