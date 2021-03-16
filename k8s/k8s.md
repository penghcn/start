## K8S
    主机、网络、存储
    POD、SERVICE

    可使用sealos快速部署

## 安装
[k8s基于centos7安装](./k8s-centos7.md)   
    
## 主机Node
    添加新节点、下线坏节点

## 网络
    1、了解。Overlay网络，容器网络的IP和MAC地址对宿主机网络不可见，跨宿主机容器间通信需要将容器流量进行封装转发，而容器出集群的流量需要进行SNAT转换
    2、推荐。扁平化的Underlay网络，容器网络对宿主机可见，在容器进行通信时不需要对流量进行封装，直接建立路由表，根据规则进行路由转发进行通信
    Flannel的host-gw模式、Calico的BGP模式
    
1、Node IP
    
    物理(或虚拟)主机自身的原来网络，Node间通信。在k8s集群之前存在
    每个Service都会在Node节点映射一个端口，外部可以通过http://NodeIP:NodePort即可访问 Service 里的 Pod 提供的服务。或者使用ingress

2、Service IP 或者 Cluster IP
    
    k8s集群中，虚拟网络，通过kube-proxy配置为iptables/ipvs规则，把流量发往后端的Pod上

3、Pod IP
    
    k8s集群中，虚拟网络，设置各Pod的IP以及Pod间通信，通过CNI插件实现
    同Pod不同容器间，通过localhost，默认互通
    同Node不同Pod间，通过docker0，默认互通
    不同Node不同Pod间，需CNI网络插件借助Node，Pod1 --> Node1 --> Node2 --> Pod2

参考下图，跨Node的Pod间通信，flannel-vxlan
![flannel-vxlan](./img/pod-node-pod.png)

跨Node的Pod间通信，flannel-host-gw
![flannel-host-gw](./img/pod-node-pod2.png)



## 存储
    emptydir、hostPath、pvc
### emptydir
    大部分应用适用该类型，随POD一起创建、消亡
### pvc
    共享文件   
    cephfs、glusterfs、nfs
