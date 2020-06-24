#!/bin/bash

export PROMPT_TIMEOUT=3600

########################
# include the magic
########################
. demo/demo-magic/demo-magic.sh

cd $(mktemp -d)
git init

# hide the evidence
clear

pwd
bold=$(tput bold)
normal=$(tput sgr0)

clear
p "# fetch the package..."
pe "kpt pkg get https://github.com/pwittrock/sig-apps-demo/etcd@v3.4.5 etcd"
wait
pe "git add . && git status && git commit -m 'add etcd package'"
pe "tree etcd/"
wait

p "# apply the package"
pe "kubectl apply -R -f etcd/"
pe "kubectl get pods -w"

p "# modify the package"
p "# list the settable options"
pe "kpt cfg list-setters etcd/"
wait

p "# set the replicas"
pe "kpt cfg set etcd/ replicas 3"
pe "git diff etcd/etcd.yaml"

pe "git add . && git status && git commit -m 'set replicas 3'"
p "# apply the updates"
pe "kubectl apply -R -f etcd/"
pe "kubectl get pods -w"

p "# update the package to later version"
pe "kpt pkg update etcd@v3.4.6 --strategy resource-merge"
wait

pe "git diff etcd/etcd.yaml"
wait

pe "git add . && git commit -m 'update to v3.4.6'"
pe "kubectl apply -R -f etcd/"
pe "kubectl get pods -w"

p "# fin"