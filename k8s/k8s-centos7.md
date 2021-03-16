# centos7.8+ 安装k8s
## 准备
    sh init_host.sh k8s-m1

    参考主机如下，操作系统都是centos7.9
    3节点master使用haproxy + keepalived实现负载均衡 VIP 10.0.7.205

角色 |主机名 |  ip
-||
master | k8s-m1 | 10.0.7.31
master | k8s-m2 | 10.0.7.32
master | k8s-m3 | 10.0.7.33
|
worker | k8s-w1 | 10.0.7.11
worker | k8s-w2 | 10.0.6.11

## 同步时间

## 安装k8s单master
    sh install_master_k8s.sh apiserver.k8s

    # 查看
    kubectl get pods -o wide --all-namespaces
    kubectl get pods -o wide -A

## 安装k8s集群
    # 在第1台master节点k8s-m1运行
    sh install_master_k8s.sh apiserver.k8 10.0.7.205

    ## 上述运行结束后，找到如下3行日志内容，等下加入第2、3台master节点需要，加入worker节点时取前2行即可
    ## 注意token时效2小时。超时请参考《附录一》
    kubeadm join apiserver.k8:6443 --token qah4f1.q891xtt3t8gmblbk \
    --discovery-token-ca-cert-hash sha256:535664219f948510f56ef00d5b1b9c2212a2e81d3c0c75687ecfa788c09d6e57 \
    --control-plane --certificate-key 429c22df0defab2329efd1454cee4df2c0d5f324614f345b6def654cc0b5dc51

    # 下面其他节点的安装可以同时进行
    # 在第2、3台master节点k8s-m2 k8s-m3 运行
    sh install_join_k8s.sh apiserver.k8 10.0.7.205 2
    sh install_join_k8s.sh apiserver.k8 10.0.7.205 3

    kubeadm join apiserver.k8:6443 --token qah4f1.q891xtt3t8gmblbk \
    --discovery-token-ca-cert-hash sha256:535664219f948510f56ef00d5b1b9c2212a2e81d3c0c75687ecfa788c09d6e57 \
    --control-plane --certificate-key 429c22df0defab2329efd1454cee4df2c0d5f324614f345b6def654cc0b5dc51

    # 在第1、2台 worker 节点k8s-w1 k8s-w2 运行
    sh install_join_k8s.sh apiserver.k8 10.0.7.205 11
    sh install_join_k8s.sh apiserver.k8 10.0.7.205 12

    kubeadm join apiserver.k8:6443 --token qah4f1.q891xtt3t8gmblbk \
    --discovery-token-ca-cert-hash sha256:535664219f948510f56ef00d5b1b9c2212a2e81d3c0c75687ecfa788c09d6e57 \

## 安装k8s集群外接etcd
    sh install_etcd_k8s.sh

## 附录一，超2小时获取kubeadm join token
只在第1个master节点k8s-m1上执行 `kubeadm init phase upload-certs --upload-certs`
    
    [root@k8s-m1 ~]# kubeadm init phase upload-certs --upload-certs
    [upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
    [upload-certs] Using certificate key:
    6fcb441698ae10b18204d28385340e70f5cbf8efbfcb7b2c577ecc4e309fc18b

接着执行 `kubeadm token create --print-join-command`
    
    [root@k8s-m1 ~]# kubeadm token create --print-join-command
    kubeadm join apiserver.k8:6443 --token c9ehvp.ogg0a6ugjq8vcyb1     --discovery-token-ca-cert-hash sha256:535664219f948510f56ef00d5b1b9c2212a2e81d3c0c75687ecfa788c09d6e57 

组合成如下命令
    
    kubeadm join apiserver.k8:6443 --token c9ehvp.ogg0a6ugjq8vcyb1 \
    --discovery-token-ca-cert-hash sha256:535664219f948510f56ef00d5b1b9c2212a2e81d3c0c75687ecfa788c09d6e57 \
    --control-plane --certificate-key 6fcb441698ae10b18204d28385340e70f5cbf8efbfcb7b2c577ecc4e309fc18b

