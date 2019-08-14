# gcp-deployment-manager

This repo contains an GCP Deployment manager template to deploy YugaByte DB cluster on GCP. It does the following:
* Creates a VPC with three public subnets
* Creates an instance in each subnet
  * Note that the instances that get created use CentOS as the OS.
* Deploys a YugaByte DB cluster across these three nodes

# Usage

## Deploying From GCloud 
[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2FYugaByte%2Fgcp-deployment-manager.git)
  - Clone this repo.
    ```
    $ git clone https://github.com/YugaByte/gcp-deployment-manager.git
    ```
  - Change current directory to cloned git repo directory
  - Use gcloud to create deployment-manager deployment <br/> 
    ```
    $ gcloud deployment-manager deployments create <your-deployment-name> --config=yugabyte-deployment.yaml
    ```
  - Wait until the creation of all resources is complete.
  - Once the deployment creation is complete, you can describe it as shown below.
    ```
    $ gcloud deployment-manager deployments describe <your-deployment-name>
    ```
    In output you will get the YugaByte DB admin URL, JDBC URL, YSQL, YCQL and YEDIS connection string. 
