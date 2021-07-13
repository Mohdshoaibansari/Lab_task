# Lab_task

## Challenge:
The Technical Challenge:

Using your own laptop or one of the Cloud Providers, deploy a Kubernetes Cluster (e.g. minikube, minishift, kind, EKS, AKS, GKE, etc...)     

Deploy CI/CD tools ( Jenkins or ArgoCD or a similar tool) on Kubernetes and demonstrate a blue green deployment of an application example (ex: nodejs dummy app).     

Document the exercise (code, config files, README) in a GitHub (or similar) repository and share it at least one day before the demo with us.     

Bonus: Provide a script that does the setup in an automated way that you manage the setup of the cluster and all the tools.

Again, Please focus on the documents on the detail what you have done and then in the next round first 30 minutes we are going to discuss the technical challenge (joys & pains, view code). Please prepare a demo of your running solution. 30 minutes we will discuss about architecture, cloud services (mostly focus on AWS/Azure), OpenShift troubleshooting, DevOps, automation, monitoring among other things.


Solution
# Folders Details:
	a. App-Development: Flask Application code. Docker file to create docker image. Application Deployment Script. Latest application Version and Latest label selector detail. YAML code for EKS deployment. Blue-Green Deployment script.
	b. Configuration: Configuration code used to configure the EKS cluster.
	c. Infra: Terraform code to deploy the aws services needed.
	d. Jenkins: YAML files to deploy the jenkins on EKS.

## Infrastructure:
Terraform is used to deployed the EKS Infrastructure on AWS. Backend is S3. Infrastructure code is present in infra folder.
### Services Created:
	1. IAM roles for cluster and nodes.
	2. EKS Cluster
	3. EKS Nodegroup
	4. ECR Repository


## Configuration Of EKS

1. Update the cluster configuration using below commoand:
    	aws eks update-kubeconfig \
	  --region eu-central-1 \
  	  --name eks-cluster-test

2. Provide access to infra-admin role using configmap/aws-auth. Reference below.
https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html




## Jenkins Deployment

  1. Jenkins is running on single pod which is running via deployment under jenkins namespace. Services is created to access the jenkins application runnin inside pods.

## Application

1. Flask basic application docker image has been created and pushed to ECR. EKS deployment is pointing to latest ECR image. Deployment is of type Blue-Green which is acheived via automation script written in shell



# Other References
### Manage User and Roles access to cluster:
https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

### alb-ingress-controller
https://kubernetes-sigs.github.io/aws-load-balancer-controller/v1.1/guide/controller/setup/#kubectl

### Clusert Auto-scaler:
https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md

### Metric Server
https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html


After creation of Cluster, configure aws-auth and required roles and user to it.
Command: kubectl apply -f aws-auth-cm.yaml


### Update kube config file:
	aws eks update-kubeconfig \
	  --region eu-central-1 \
  	  --name eks-cluster-test




### Commands:
kubectl get pods --all-namespaces | grep Running | wc -l
kubectl get node -o yaml | grep pods
