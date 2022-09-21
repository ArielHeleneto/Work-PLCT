# Running Docker on Ubuntu 22.04.1 Server riscv64

> Last Modified: 2022-09-15T21:59+8

## Download Ubuntu 22.04.1 Server riscv64 Image

Click [here](https://cdimage.ubuntu.com/releases/22.04.1/release/ubuntu-22.04.1-preinstalled-server-riscv64+unmatched.img.xz) to download it.

We do wish you successfully run it before you start reading the content below.

## System Info

```bash
root@ubuntu:/home/ubuntu# neofetch
            .-/+oossssoo+/-.               ubuntu@ubuntu
        `:+ssssssssssssssssss+:`           -------------
      -+ssssssssssssssssssyyssss+-         OS: Ubuntu 22.04.1 LTS riscv64
    .ossssssssssssssssssdMMMNysssso.       Host: riscv-virtio,qemu
   /ssssssssssshdmmNNmmyNMMMMhssssss/      Kernel: 5.15.0-1016-generic
  +ssssssssshmydMMMMMMMNddddyssssssss+     Uptime: 41 mins
 /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    Packages: 670 (dpkg), 4 (snap)
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Shell: bash 5.1.16
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Resolution: 1280x800
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   Terminal: /dev/pts/0
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   CPU: (8)
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   GPU: 00:02.0 Red Hat, Inc. Virtio GPU
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Memory: 242MiB / 7938MiB
 /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/
  +sssssssssdmydMMMMMMMMddddyssssssss+
   /ssssssssssshdmNNNNmyNMMMMhssssss/
    .ossssssssssssssssssdMMMNysssso.
      -+sssssssssssssssssyyyssss+-
        `:+ssssssssssssssssss+:`
            .-/+oossssoo+/-.

```

## Docker

### Install Docker

Because Docker is an unsandboxed program, we do suggest you tou change to root.

You can download Docker deb file from [carlosedp/riscv-bringup](https://github.com/carlosedp/riscv-bringup/releases/tag/v1.0). When writing this article, `docker-v20.10.2-dev_riscv64.deb` was released and can be used in Ubuntu.

```bash
apt update
wget https://github.com/carlosedp/riscv-bringup/releases/download/v1.0/docker-v20.10.2-dev_riscv64.deb
dpkg -i ./docker-v20.10.2-dev_riscv64.deb -y
```

Then you can start docker service manually if it is not working.

```bash
systemctl start docker
```

Use `docker info` to get info.

```bash
root@ubuntu:/home/ubuntu# docker info
Client:
 Context:    default
 Debug Mode: false

Server:
 Containers: 1
  Running: 1
  Paused: 0
  Stopped: 0
 Images: 1
 Server Version: dev
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 969b3d638bbf5fe0296f7b80adda24838266e92e
 runc version: 0ae14750669f42209a1f974943408df754148e9d
 init version: b9f42a0 (expected: de40ad0)
 Security Options:
  apparmor
  cgroupns
 Kernel Version: 5.15.0-1016-generic
 Operating System: Ubuntu 22.04.1 LTS
 OSType: linux
 Architecture: riscv64
 CPUs: 8
 Total Memory: 7.752GiB
 Name: ubuntu
 ID: KYOF:6SA7:GYA7:VMSU:KOG2:5HYH:QUMD:GLNR:734W:7URD:OXPS:SOMC
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false

WARNING: No kernel memory limit support
WARNING: No oom kill disable support
```

Use `docker info` to get info.

```bash
root@ubuntu:/home/ubuntu# docker version
Client:
 Version:           unknown-version
 API version:       1.41
 Go version:        go1.16.2
 Git commit:        d3c36a2a73
 Built:             Thu Mar 18 22:37:13 2021
 OS/Arch:           linux/riscv64
 Context:           default
 Experimental:      true

Server:
 Engine:
  Version:          dev
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.2
  Git commit:       788f2883d2
  Built:            Thu Mar 18 23:11:36 2021
  OS/Arch:          linux/riscv64
  Experimental:     false
 containerd:
  Version:          v1.5.0-beta.4-20-g969b3d638
  GitCommit:        969b3d638bbf5fe0296f7b80adda24838266e92e
 runc:
  Version:          1.0.0-rc93+dev
  GitCommit:        0ae14750669f42209a1f974943408df754148e9d
 docker-init:
  Version:          0.19.0
  GitCommit:        b9f42a0
```

### Start your first Docker container

We will use `carlosedp/echo_on_riscv` to start it.

```bash
docker run -d -p 8080:8080 carlosedp/echo_on_riscv
curl http://localhost:8080
```

## Kubernetes

### Install Kubernetes

```bash
sudo apt update
sudo apt install -y conntrack ebtables socat

sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

wget https://github.com/carlosedp/riscv-bringup/releases/download/v1.0/kubernetes_1.16.0_riscv64.deb
sudo dpkg -i kubernetes_1.16.0_riscv64.deb

# Pre-fetch Kubernetes images
sudo kubeadm config images pull --image-repository=carlosedp --kubernetes-version 1.16.0

# Init cluster
sudo kubeadm init --image-repository=carlosedp --kubernetes-version 1.16.0 --ignore-preflight-errors SystemVerification,KubeletVersion --pod-network-cidr=10.244.0.0/16

# Adjust livenessProbe for apiserver
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | sed -e 's/\(\s*initialDelaySeconds\).*/\1: 150/'
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | sed -e 's/\(\s*timeoutSeconds\).*/\1: 60/'

# Deploy Flannel network
kubectl apply -f https://gist.github.com/carlosedp/337b99a98cdcf5962f4a0e24a778994c/raw/kube-flannel.yml

#Allow pod scheduling on master node

kubectl taint nodes --all node-role.kubernetes.io/master-
```
