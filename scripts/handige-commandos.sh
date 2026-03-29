kubectl exec etcd-control-node1 -n kube-system -- etcd --version

ETCDCTL_API=3 etcdctl --endpoints 10.0.0.4:2379 \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  member list