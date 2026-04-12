kubectl apply -f https://dev.azure.com/RIVMNL/cpt-jbonsel/_git/k8s?path=/information/yamlfiles/deploypods/deploy-alpine-nginx.yaml&version=GBmain



#chapter 6

# context info:
sudo cat $HOME/.kube/config
kubectl config view

#switch context
kubectl config use-context CONTEXT_NAME
kubectl config use-context jeroenscontext

#new user:
kubectl config set-credentials new-admin --client-key=new-admin.key --client-certificate=new-admin.crt --embed-certs=true

#4 default roles:
cluster-admin
admin
edit
view

#create custom role:
kubectl create role pod-reader --verb=get --verb=list --verb=watch --resource=pods
kubectl create role pod-reader --verb=get,list,watch --resource=pods

kubectl delete role pod-reader

###ROLEBINDING###
kubectl create rolebinding readonly-pods-binding --role=pod-reader --user=new-admin

###create service account
kubectl get serviceaccounts

kubectl create serviceaccount jeroenbot1
