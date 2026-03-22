ssh jeroen@20.54.73.250

sudo apt update && sudo apt upgrade -y

sudo modprobe overlay
sudo modprobe br_netfilter

#Create a configuration file as shown and specify the modules to load them permanently.

sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

#Create a Kubernetes configuration file in the /etc/sysctl.d/ directory.

sudo nano /etc/sysctl.d/k8s.conf
#Add the following lines:

net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward   = 1

#Kubernetes relies on a container runtime. We’ll use containerd, a widely supported and performant option:

sudo apt install -y containerd

# Generate default config
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo nano /etc/containerd/config.toml
# Then find SystemdCgroup change its value from false to true

sudo systemctl restart containerd;sudo reboot

# Enable and start the service
sudo systemctl restart containerd
sudo systemctl enable containerd

#Install kubeadm, kubelet, and kubectl
#Run these commands on all nodes (control plane and workers):

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
# Download the public signing key for the Kubernetes package repositories. The same signing key is used for all repositories so you can disregard the version in the URL:

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key |sudo sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# Prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize the Control Plane (on Master Node Only)
# Now on your control-plane node only, run:

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# use kubectl without sudo:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#install CNI
# oude versie: kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/custom-resources.yaml

watch kubectl get tigerastatus

#join worker node:
sudo kubeadm join 10.0.0.4:6443 --token gte3di.xe53uf0w2b280208 --discovery-token-ca-cert-hash sha256:50e57ddd413c6930d4f8ff17beac8b936f62468a89578525893fab593ab96269
#To verify:
kubectl get nodes