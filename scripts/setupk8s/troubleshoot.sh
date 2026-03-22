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