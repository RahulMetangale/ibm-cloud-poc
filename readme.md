
## Getting started with IBM Cloud

1. Sign up for free account on <https://cloud.ibm.com>.
2. Create IBM Cloud API Key. Please follow the steps given here. <https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui#create_user_key>

## Steps to setup environment:
Please follow steps given below to setup landing zone. These steps will create resource group, Kubernetes  cluster free version and container registry. 
1. Navigate to infrastructure  directory  
``cd infrastructure ``
2. Initialize terraform working directory  
   ``terraform init``  
3. Set API key environment variable
 export  
 ``TF_VAR_ibmcloud_api_key="Your IBM Cloud API Key"``
3. Create terraform plan  
``terraform plan -out deployment.tfplan``
4. Verify the plan output
5. Apply the plan  
``terraform apply -input=false -auto-approve deployment.tfplan``

## Create Docker Image & Push to Container Registry
### Test Service Locally
1. Navigate to below directory.  
   ``cd services/hello-ibm-cloud``
2. Run below command to install required node packages.  
   ``npm install``
3. Now to test the service run following command. 
   ``node server.js``
4. Now from web browser try accessing link http://localhost:3000. You should see below message on webpage.  
   ``Hello from IBM IKS!``

### Build Docker Image
1. Run following command from directory hello-ibm-cloud.  
   ``docker build . -t poc/hello-ibm-cloud``

### Test Docker Container Locally
1. Run following command to run image created in above step.  
   ``docker run -d -p 3000:3000 poc/hello-ibm-cloud``
2. Now from web browser try accessing link http://localhost:3000. You should see below message on webpage.  
   ``Hello from IBM IKS!``

### Push Image to Container Registry

1. Login in to container registry. On https://cloud.ibm.com Navigate to container registry - quick start and follow all the steps given on the page to log in to container registry. 

2. Now tag the docket image.  
``docker tag poc/hello-ibm-cloud icr.io/poccontainerregistry/hello-ibm-cloud``
3. Run following command to push the image to registry.  
   ``docker push icr.io/poccontainerregistry/hello-ibm-cloud``

## Deploy Service to IBM Kubernetes Service

### Connect to Kubernetes Cluster

1. Install IBM cli if not installed already. Please follow steps given blow for the same. <https://cloud.ibm.com/docs/cli?topic=cli-getting-started>
2. Install Kubernetes and container registry plugin. Steps are covered in above article.
3. Now login to https://cloud.ibm.com. Click on hamburger menu on the top left corner.
4. Select Kubernetes and then click on cluster to view the cluster created by landing zone.
5. Now click on ellipses on the right and select connect via cli. And follow the steps given in the window that opens.

6. Run following command to verify connection to Kubernetes cluster. Kubectl is required to run below command. Please follow steps given in below link to install kubectl. https://kubernetes.io/docs/tasks/tools/  
   ``kubectl get nodes``

### Run Platform Deployment

Purpose of platform deployment is to create namespaces, deploy required secrets, network policies etc.

1. Navigate to platform directory.  
   ``cd /pltform``
2. Create system namespace to deploy service
   ``kubectl apply -f namespaces.yaml``
3. When container registries are created automatic access is granted to them. However the required secret is only available in default namespace. Since different namespace is used to deploy service, it is required to deploy the same secret to system namespace.  
``kubectl apply -f all-to-cr-io.yaml``

### Deploy sample service
In this example free Kubernetes service is being used. It only supports exposing service on nodeport. Its not ideal but its fine for PoC.
Run following commands from hello-ibm-cloud - Deploy directory.
1. Create Deployment  
   ``kubectl apply -f deployment.yaml``
2. Deploy service using type nodeport. This will expose service on Kubernetes nodes port. And service can be accessed using ``http://<kubernetes service public ip>:<node port>``

### Get Nodes Public IP

1. Run following command to get worker nodes public IP. Here in PoC is the name of Kubernetes cluster.  
   ``ibmcloud ks worker ls --cluster poc`` 

### Access the service
To access service from internet use following url
``http://<public ip of worker node>:<node port>``
Where public ip is same as obtained in above step and node port is the port mentioned in service.yaml file.

## Note

1. IBM Kuberntes service free version only support exposing service over node port. Ref: <https://cloud.ibm.com/docs/containers?topic=containers-cs_network_planning>

## Technical Debt

1. Create build and deployment pipelines.
2. Create VLAN, subnet etc so that every time terraform apply is run Kubernetes cluster is not destroyed and recreated.
3. Add secrets to vault.

   
## Troubleshooting

1. Error Transaction Rejected. Please contact Cloud Trust Enablement at verify@us.ibm.com for further information.  
When you are creating IBM cloud account for the first time. By default account will be kept in suspended state. You will have to drop an email to above email id. After verification account will be activated. This process takes approximately 24hrs.
