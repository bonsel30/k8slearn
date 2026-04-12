kubectl exec etcd-control-node1 -n kube-system -- etcd --version

ETCDCTL_API=3 etcdctl --endpoints 10.0.0.4:2379 \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  member list

# Alle kubernetes resources plus api versie
kubectl api-resources | sort

#restart all pods in a namespace in a deployment:
kubectl rollout restart deployment -n olm


#namespace events:
kubectl -n olm get event