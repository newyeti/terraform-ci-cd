
# Doker 

## Docker Server
https://docs.oracle.com/en-us/iaas/Content/Registry/Concepts/registryprerequisites.htm#Preparing_for_Registry

## Docker Login

Username: <object-storage-namespace>/<username>
Password: Generate Toker

```
docker login -u <object-storage-namespace>/<username> <docker server>
```

## Give Access to Docker for Kubernetes
```
kubectl -n <namespace> create secret docker-registry free-registry-secret --docker-server=<docker-server> --docker-username='<object-storage-namespace>/<username>' --docker-password='<password>'
```

# Resource
```
# Blog Post
https://arnoldgalovics.com/oracle-kubernetes-free-network-load-balancer/

# Github Repository
https://github.com/galovics/free-kubernetes-oracle-cloud-terraform/tree/nlb/oci-infra

```
