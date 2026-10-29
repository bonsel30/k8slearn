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


sudo ufw status
# If UFW is active, you can allow required ports like so:

sudo ufw allow 6443/tcp
sudo ufw allow 10250/tcp


sudo systemctl restart kubelet

# To generate a new one on the control-plane node:

sudo kubeadm token create --print-join-command

# Kubernetes v1.26+ requires containerd v1.6.0+. Some Ubuntu releases may include older versions in the default repos. Check your installed version:

containerd --version

#net zoiets als netstat -na
ss -nltp

#install calicoctl
https://docs.tigera.io/calico/latest/operations/calicoctl/install
curl -L https://github.com/projectcalico/calico/releases/download/v3.31.4/calicoctl-linux-amd64 -o calicoctl
of
curl -L https://github.com/projectcalico/calico/releases/download/v3.31.4/calicoctl-linux-amd64 -o kubectl-calico
chmod +x ./calicoctl
sudo mv ./calicoctl /usr/local/bin/


kubectl logs -n kube-system calico-kube-controllers-6d76546c4c-zl9jm