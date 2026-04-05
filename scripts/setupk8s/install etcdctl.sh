https://kifarunix.com/how-to-install-etcdctl-on-kubernetes-cluster/


kubectl get pods -n kube-system -l component=etcd
kubectl exec etcd-master-01 -n kube-system -- etcd --version

ETCD_VER=v3.6.6

wget https://storage.googleapis.com/etcd/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -P /tmp/

tar tf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

sudo tar -xzf /tmp/etcd-v3.5.12-linux-amd64.tar.gz -C /usr/local/bin/ etcd-${ETCD_VER}-linux-amd64/etcdctl --strip-components=1
en 
sudo tar -xzf /tmp/etcd-v3.5.12-linux-amd64.tar.gz -C /usr/local/bin/ etcd-${ETCD_VER}-linux-amd64/etcdutl --strip-components=1


which etcdctl

/usr/local/bin/etcdctl


etcdctl version

