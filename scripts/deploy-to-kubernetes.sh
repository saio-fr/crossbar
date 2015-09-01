#! /bin/bash

# install kubernetes client
if [ ! -d ~/kubernetes ]; then
  export KUBERNETES_VERSION=1.0.3
  mkdir ~/kubernetes
  curl -L https://github.com/kubernetes/kubernetes/releases/download/v${KUBERNETES_VERSION}/kubernetes.tar.gz > /tmp/kubernetes.tar.gz
  tar xzvf /tmp/kubernetes.tar.gz -C ~
  rm -f /tmp/kubernetes.tar.gz
  chmod +x ~/kubernetes/cluster/kubectl.sh
fi

# create service & rc
mkdir scripts/build
chmod +x scripts/create-crossbar-controller.yml.sh && scripts/create-crossbar-controller.yml.sh
chmod +x scripts/create-crossbar-public-service.yml.sh && scripts/create-crossbar-public-service.yml.sh
chmod +x scripts/create-crossbar-private-service.yml.sh && scripts/create-crossbar-private-service.yml.sh

# export kubectl parameters
export KUBERNETES_KUBECTL=~/kubernetes/cluster/kubectl.sh
export KUBERNETES_CMD="$KUBERNETES_KUBECTL --server=${KUBERNETES_SERVER} --username=${KUBERNETES_USERNAME} --password=${KUBERNETES_PASSWORD} --insecure-skip-tls-verify=true"

$KUBERNETES_CMD config set-context staging --namespace=staging --cluster=saio-fr_kubernetes --user=saio-fr_kubernetes
$KUBERNETES_CMD config set-context production --namespace=production --cluster=saio-fr_kubernetes --user=saio-fr_kubernetes

# Switch k8 namespaces (prod, staging...) based on current branch
if [ "$CIRCLE_BRANCH" = "develop" ]; then
    echo 'Using staging namespace'
    $KUBERNETES_CMD config use-context staging
fi

if [ "$CIRCLE_BRANCH" = "master" ]; then
    echo 'Using production namespace'
    $KUBERNETES_CMD config use-context production
fi

if [ $($KUBERNETES_CMD get services | grep -c crossbar) -ne 1 ]; then
    echo "Create crossbar service"
    $KUBERNETES_CMD create -f scripts/build/crossbar-public-service.yml
    $KUBERNETES_CMD create -f scripts/build/crossbar-private-service.yml
fi

if [ $($KUBERNETES_CMD get rc | grep -c crossbar) -ne 1 ]; then
    echo "Create crossbar rc"
    $KUBERNETES_CMD create -f scripts/build/crossbar-controller.yml
else
    echo "Rolling update crossbar rc"
    $KUBERNETES_CMD rolling-update crossbar --update-period=10s --image=${EXTERNAL_REGISTRY_ENDPOINT}/crossbar:${CIRCLE_BRANCH}_${CIRCLE_SHA1}
fi
