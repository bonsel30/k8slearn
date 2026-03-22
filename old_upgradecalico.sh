# Upgrading an installation that uses an etcd datastore
# Download the v3.31 manifest that corresponds to your original installation method.

Calico for policy and networking

curl https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/calico-etcd.yaml -o upgrade.yaml


# Calico for policy and flannel for networking

# curl https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/canal-etcd.yaml -o upgrade.yaml


# note
# You must manually apply the changes you made to the manifest during installation to the downloaded v3.31 manifest. At a minimum, you must set the etcd_endpoints value.

# Use the following command to initiate a rolling update.

kubectl apply --server-side --force-conflicts -f upgrade.yaml

# Watch the status of the upgrade as follows.

watch kubectl get pods -n kube-system

# Verify that the status of all Calico pods indicate Running.

calico-kube-controllers-6d4b9d6b5b-wlkfj   1/1       Running   0          3m
calico-node-hvvg8                          1/2       Running   0          3m
calico-node-vm8kh                          1/2       Running   0          3m
calico-node-w92wk                          1/2       Running   0          3m

# tip
# The calico-node pods will report 1/2 in the READY column, as shown.

Remove any existing calicoctl instances, install the new calicoctl and configure it to connect to your datastore.

Use the following command to check the Calico version number.

calicoctl version

It should return a Cluster Version of v3.31.

If you have enabled application layer policy, follow the instructions below to complete your upgrade. Skip this if you are not using Istio with Calico.

If you were upgrading from a version of Calico prior to v3.14 and followed the pre-upgrade steps for host endpoints above, review traffic logs from the temporary policy, add any global network policies needed to allow traffic, and delete the temporary network policy allow-all-upgrade.

Congratulations! You have upgraded to Calico v3.31.