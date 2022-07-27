EKS CLUSTER HOSTING:
====================

1. Developed the Terraform script for automating the creation of EKS cluster in AWS.

Script Path: 

2. After successfull creation of EKS, need to setup the ingress controller to access our applications from the outside/external  and ONE MORE Option we can use is AWS ELB config in eks

I am going to install the nginx ingress controller in eks cluster.

2.1.Prerequistes:

     - Need to login aws eks , use the below command to configure/login to aws account.
	    # aws configure 
		
		   AWS Access Key ID [****************3sev]:
		   AWS Secret Access Key [****************ddeb]:
		   Default region name [us-east-1]:
		   Default region name [us-east-1]:
		   
	 - Validate the EKS cluster connection by using kubectl .
	 
2.2. Installing the nginx ingress controller, I have used official page with slight changes to work properly.

     -  Download the NGINX Ingress Controller for Kubernetes:
	 
	    # git clone https://github.com/nginxinc/kubernetes-ingress.git
	 
	 -  Choose the directory for deploying the Ingress Controller:
	   
	    # cd kubernetes-ingress/deployments/
		
	 -  Create a dedicated namespace, service account, and TLS certificates (with a key) for the default server:
	 
	    # kubectl apply -f common/ns-and-sa.yaml
        # kubectl apply -f common/default-server-secret.yaml
	
	 -  Create a ConfigMap for customizing your NGINX configuration:
	 
	    # kubectl apply -f common/nginx-config.yaml
	 
	 -  Configure role-based access control (RBAC), create a ClusterRole, and then bind the ClusterRole to the service account from step 3. For example:
	 
	    # kubectl apply -f rbac/rbac.yaml
		
	 -  If your Kubernetes cluster version is greater than or equal to 1.18, then create an NGINX Ingress class:
	 
	    # kubectl apply -f common/ingress-class.yaml
		
		NOTE: when applying this you may get below error
		
		 error: resource mapping not found for name: "nginx" namespace: "" from "common/ingress-class.yaml": no matches for kind "IngressClass" in version "networking.k8s.io/v1beta1" 
         
		 Solution: 
		     Update the apiVersion: networking.k8s.io/v1 in common/ingress-class.yaml file and reapply it , will work.
	
	 -  Deploy the Ingress Controller:
	 
	    # kubectl apply -f deployment/nginx-ingress.yaml
		
		  NOTE: applied successfully but getting crashloop backoff error.
		  
		  nginx-ingress   nginx-ingress-5b95958c76-lcjtz        0/1     CrashLoopBackOff   4 (72s ago)   2m42s
		  
		  --- When I checked logs i can see below error 
		  
		          main.go:300] Error when getting IngressClass nginx: the server could not find the requested resource 
		  
		      By seeing this i understood some resources still missed, so when i was browsing i found that i missed the crds creation for ingress controller.
			  
		  SOLUTION:
		       So I said I installed below files, after successfull deployment it worked fine.
			   
			      #  kubectl apply -f common/crds/k8s.nginx.org_virtualserverroutes.yaml
				  #  kubectl apply -f common/crds/k8s.nginx.org_globalconfigurations.yaml
				  #  kubectl apply -f common/crds/k8s.nginx.org_policies.yaml
				  #  kubectl apply -f common/crds/k8s.nginx.org_transportservers.yaml
				  #  kubectl apply -f common/crds/k8s.nginx.org_virtualservers.yaml
				  
			Result: 
			  nginx-ingress   nginx-ingress-b7f588cc5-79lgt         1/1     Running   0             8m8s
			  
	 -  Apply your configuration for using LB
	 
	     # kubectl apply -f service/loadbalancer-aws-elb.yaml
		 
		 # kubectl get svc --namespace=nginx-ingress
		 
		 We should see the result like below
		    - PS C:\WINDOWS\system32> kubectl get svc --namespace=nginx-ingress
            NAME            TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)                      AGE
            nginx-ingress   LoadBalancer   10.100.65.245   a184505796fba408fb32e9b5e1e01874-754576039.us-east-1.elb.amazonaws.com   80:31716/TCP,443:30215/TCP   13s

3. After successfull ingress deployment, we need to deploy our application using our earlier manifest files.

       # kubectl apply -f kubernetes-deploy.yml
	   # kubectl apply -f frontend-app.yml
	   
4. BY using AWS ELB external ip URL is : http://affa4c1483f8647518aaa82d3579ad72-1218257215.us-east-1.elb.amazonaws.com/ 