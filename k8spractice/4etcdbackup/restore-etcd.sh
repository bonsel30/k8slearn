kubectl get pods -A
kubectl describe pod etcd-control-node1 -n kube-system
# of:
kubectl describe pod etcd-control-node1 -n kube-system | grep -e crt -e key
kubectl describe pod etcd-control-node1 -n kube-system | grep -e server. -e ca.

sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt \
> --cert=/etc/kubernetes/pki/etcd/server.crt \
> --key=/etc/kubernetes/pki/etcd/server.key \
> snapshot save /opt/etc-backup-28032026.db

 sudo ETCDCTL_API=3 etcdutl --data-dir=/var/lib/from-backup snapshot restore /opt/etc-backup-28032026.db


sudo nano /etc/kubernetes/manifests/etcd.yaml
# Verander hostpath entry naar restored file (/var/lib/from-backup) oud = path: /var/lib/etcd

 kubectl describe pod etcd-control-node1 -n kube-system
Name:                 etcd-control-node1
Namespace:            kube-system
etc....
      etcd
      --advertise-client-urls=https://10.0.0.4:2379
      --cert-file=/etc/kubernetes/pki/etcd/server.crt   <-------cert
      --client-cert-auth=true
      --data-dir=/var/lib/etcd
      --feature-gates=InitialCorruptCheck=true
      --initial-advertise-peer-urls=https://10.0.0.4:2380
      --initial-cluster=control-node1=https://10.0.0.4:2380
      --key-file=/etc/kubernetes/pki/etcd/server.key   <-------key
      --listen-client-urls=https://127.0.0.1:2379,https://10.0.0.4:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://10.0.0.4:2380
      --name=control-node1
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --snapshot-count=10000
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt    <-------cacert
      --watch-progress-notify-interval=5s


# -------------------EXTRA-----------------------

 kubectl describe pod etcd-control-node1 -n kube-system
Name:                 etcd-control-node1
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 control-node1/10.0.0.4
Start Time:           Sat, 28 Mar 2026 06:16:23 +0000
Labels:               component=etcd
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/etcd.advertise-client-urls: https://10.0.0.4:2379
                      kubernetes.io/config.hash: 394ef30925ce2f791cfa6aa04aef9c41
                      kubernetes.io/config.mirror: 394ef30925ce2f791cfa6aa04aef9c41
                      kubernetes.io/config.seen: 2026-03-18T13:39:02.727658094Z
                      kubernetes.io/config.source: file
Status:               Running
SeccompProfile:       RuntimeDefault
IP:                   10.0.0.4
IPs:
  IP:           10.0.0.4
Controlled By:  Node/control-node1
Containers:
  etcd:
    Container ID:  containerd://c037e0eb68a417f9b161339a369a3f934cc8710e41e946b82775ff83faefcb08
    Image:         registry.k8s.io/etcd:3.6.6-0
    Image ID:      registry.k8s.io/etcd@sha256:60a30b5d81b2217555e2cfb9537f655b7ba97220b99c39ee2e162a7127225890
    Port:          2381/TCP (probe-port)
    Host Port:     2381/TCP (probe-port)
    Command:
      etcd
      --advertise-client-urls=https://10.0.0.4:2379
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --client-cert-auth=true
      --data-dir=/var/lib/etcd
      --feature-gates=InitialCorruptCheck=true
      --initial-advertise-peer-urls=https://10.0.0.4:2380
      --initial-cluster=control-node1=https://10.0.0.4:2380
      --key-file=/etc/kubernetes/pki/etcd/server.key
      --listen-client-urls=https://127.0.0.1:2379,https://10.0.0.4:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://10.0.0.4:2380
      --name=control-node1
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --snapshot-count=10000
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --watch-progress-notify-interval=5s
    State:          Running
      Started:      Sat, 28 Mar 2026 06:16:27 +0000
    Last State:     Terminated
      Reason:       Unknown
      Exit Code:    255
      Started:      Sat, 28 Mar 2026 05:48:04 +0000
      Finished:     Sat, 28 Mar 2026 06:15:38 +0000
    Ready:          True
    Restart Count:  9
    Requests:
      cpu:        100m
      memory:     100Mi
    Liveness:     http-get http://127.0.0.1:probe-port/livez delay=10s timeout=15s period=10s #success=1 #failure=8
    Readiness:    http-get http://127.0.0.1:probe-port/readyz delay=0s timeout=15s period=1s #success=1 #failure=3
    Startup:      http-get http://127.0.0.1:probe-port/readyz delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
      /var/lib/etcd from etcd-data (rw)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  etcd-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/pki/etcd
    HostPathType:  DirectoryOrCreate
  etcd-data:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/etcd  <-----voor backup/restore
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:
  Type     Reason          Age   From     Message
  ----     ------          ----  ----     -------
  Normal   SandboxChanged  39m   kubelet  Pod sandbox changed, it will be killed and re-created.
  Normal   Pulled          39m   kubelet  spec.containers{etcd}: Container image "registry.k8s.io/etcd:3.6.6-0" already present on machine and can be accessed by the pod
  Normal   Created         39m   kubelet  spec.containers{etcd}: Container created
  Normal   Started         39m   kubelet  spec.containers{etcd}: Container started
  Warning  Unhealthy       39m   kubelet  spec.containers{etcd}: Startup probe failed: Get "http://127.0.0.1:2381/readyz": dial tcp 127.0.0.1:2381: connect: connection refused      
  Normal   SandboxChanged  11m   kubelet  Pod sandbox changed, it will be killed and re-created.
  Normal   Pulled          11m   kubelet  spec.containers{etcd}: Container image "registry.k8s.io/etcd:3.6.6-0" already present on machine and can be accessed by the pod
  Normal   Created         11m   kubelet  spec.containers{etcd}: Container created
  Normal   Started         11m   kubelet  spec.containers{etcd}: Container started

kubectl describe pod etcd-control-node1 -n kube-system
Name:                 etcd-control-node1
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 control-node1/
Labels:               component=etcd
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/etcd.advertise-client-urls: https://10.0.0.4:2379
                      kubernetes.io/config.hash: 19ac95383c700480db292931b67a299c
                      kubernetes.io/config.mirror: 19ac95383c700480db292931b67a299c
                      kubernetes.io/config.seen: 2026-03-28T06:56:03.317879778Z
                      kubernetes.io/config.source: file
Status:               Pending
SeccompProfile:       RuntimeDefault
IP:
IPs:                  <none>
Controlled By:        Node/control-node1
Containers:
  etcd:
    Image:      registry.k8s.io/etcd:3.6.6-0
    Port:       2381/TCP (probe-port)
    Host Port:  2381/TCP (probe-port)
    Command:
      etcd
      --advertise-client-urls=https://10.0.0.4:2379
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --client-cert-auth=true
      --data-dir=/var/lib/etcd
      --feature-gates=InitialCorruptCheck=true
      --initial-advertise-peer-urls=https://10.0.0.4:2380
      --initial-cluster=control-node1=https://10.0.0.4:2380
      --key-file=/etc/kubernetes/pki/etcd/server.key
      --listen-client-urls=https://127.0.0.1:2379,https://10.0.0.4:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://10.0.0.4:2380
      --name=control-node1
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --snapshot-count=10000
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --watch-progress-notify-interval=5s
    Requests:
      cpu:        100m
      memory:     100Mi
    Liveness:     http-get http://127.0.0.1:probe-port/livez delay=10s timeout=15s period=10s #success=1 #failure=8
    Readiness:    http-get http://127.0.0.1:probe-port/readyz delay=0s timeout=15s period=1s #success=1 #failure=3
    Startup:      http-get http://127.0.0.1:probe-port/readyz delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
      /var/lib/etcd from etcd-data (rw)
Volumes:
  etcd-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/pki/etcd
    HostPathType:  DirectoryOrCreate
  etcd-data:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/from-backup  <-----na backup/restore
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:
  Type    Reason   Age   From     Message
  ----    ------   ----  ----     -------
  Normal  Pulled   118s  kubelet  spec.containers{etcd}: Container image "registry.k8s.io/etcd:3.6.6-0" already present on machine and can be accessed by the pod
  Normal  Created  118s  kubelet  spec.containers{etcd}: Container created
  Normal  Started  118s  kubelet  spec.containers{etcd}: Container started



  sudo cat /etc/kubernetes/manifests/etcd.yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/etcd.advertise-client-urls: https://10.0.0.4:2379
  labels:
    component: etcd
    tier: control-plane
  name: etcd
  namespace: kube-system
spec:
  containers:
  - command:
    - etcd
    - --advertise-client-urls=https://10.0.0.4:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt
    - --client-cert-auth=true
    - --data-dir=/var/lib/etcd
    - --feature-gates=InitialCorruptCheck=true
    - --initial-advertise-peer-urls=https://10.0.0.4:2380
    - --initial-cluster=control-node1=https://10.0.0.4:2380
    - --key-file=/etc/kubernetes/pki/etcd/server.key
    - --listen-client-urls=https://127.0.0.1:2379,https://10.0.0.4:2379
    - --listen-metrics-urls=http://127.0.0.1:2381
    - --listen-peer-urls=https://10.0.0.4:2380
    - --name=control-node1
    - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
    - --peer-client-cert-auth=true
    - --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --snapshot-count=10000
    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --watch-progress-notify-interval=5s
    image: registry.k8s.io/etcd:3.6.6-0
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /livez
        port: probe-port
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: etcd
    ports:
    - containerPort: 2381
      name: probe-port
      protocol: TCP
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTP
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /var/lib/etcd
      name: etcd-data
    - mountPath: /etc/kubernetes/pki/etcd
      name: etcd-certs
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd
      type: DirectoryOrCreate
    name: etcd-data
status: {}