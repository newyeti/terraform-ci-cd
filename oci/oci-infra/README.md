# KubeConfig
```
oci ce cluster create-kubeconfig --cluster-id <cluster OCID> --file ~/.kube/free-k8s-config --region <region> --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
```

# Set Environment Variable
```
export KUBECONFIG=~/.kube/free-k8s-config
```

# Cluster Nodes
```
$ kubectl get nodes
```

# Resource
```
# Blog Post
https://arnoldgalovics.com/oracle-cloud-kubernetes-terraform/

# Github Repository
https://github.com/galovics/free-kubernetes-oracle-cloud-terraform/tree/cluster-creation/oci-infra

```

oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.iad.aaaaaaaapkwalh2zdxf4azqhz6x6uoqngrlgopamd5oijfafacvlagwwsq5a --file ~/.kube/newyeti-k8s-config --region us-ashburn-1 --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT