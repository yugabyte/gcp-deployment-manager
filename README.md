# Google Cloud Deployment Manager for YugabyteDB

This repo contains a Google Cloud Deployment manager template to deploy YugabyteDB cluster on GCP. This is an automated deployment that can deploy a multi-zone YugabyteDB cluster to GCP. The deployed YugabyteDB cluster gets hosted on 3 nodes residing in 3 separate public subnets and create a universe among them. 
This repo is ideal to get you running a YugabyteDB cluster in a few steps. 

# Usage

## Deploying From Google Cloud 
[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fyugabyte%2Fgcp-deployment-manager.git)
  - First clone this repo.
    ```
    $ git clone https://github.com/yugabyte/gcp-deployment-manager.git
    ```
  - Change current directory to cloned git repo directory
  - Use gcloud command to create deployment-manager deployment <br/> 
    ```
    $ gcloud deployment-manager deployments create <your-deployment-name> --config=yugabyte-deployment.yaml
    ```
  - Wait for 5-10 minutes after the creation of all resources is complete by the above command.
  - Once the deployment creation is complete, you can describe it as shown below.
    ```
    $ gcloud deployment-manager deployments describe <your-deployment-name>
    ```
    In the output, you will get the YugabyteDB admin URL, JDBC URL, YSQL, YCQL and YEDIS connection string. You can use YugabyteDB admin URL to access admin portal. 
