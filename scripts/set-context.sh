
kubectl config current-context

kubectl config get-contexts




kubectl config set-context examset1 --namespace namespacetest


kubectl config set-cluster minikube --server https://192.168.49.2:8443 --certificate-authority $USER/minikube/ca.crt