# Setup the project 

## Service Account and IAM

First of all, you have to register and download the Gcloud console and SDK. One time we've made that we create a new project 
```
gcloud init
```


After that, you need to create a Service Account and assign following roles: Storage Admin, Kubernetes Engine Admin, Compute Admin, Service Account User or use Owner/role and create a key.

### Create the service account:
```
$ gcloud iam service-accounts create kindone-automation \
  --description "SA used for ${PROJECT} Actions" \
  --display-name "${PROJECT}-automation"
```
### Assign the owner role to the service account
```
$ gcloud projects add-iam-policy-binding ${PROJECT} \
  --member serviceAccount:${PROJECT}-automation@${PROJECT}.iam.gserviceaccount.com \
  --role roles/owner
```
### Create service account keys
```
gcloud iam service-accounts keys create \
  ~/.config/gcloud/application_default_credentials.json \
  --iam-account ${PROJECT}-automation@${PROJECT}.iam.gserviceaccount.com
```
### Activate the Service Account 
Now you have to activate the service or export the key for the console, in follow:
```
$ export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json
```

or

```
$ gcloud auth activate-service-account --key-file ~/.config/gcloud/application_default_credentials.json
```



# Run Terragrunt


## Update Terraform Inputs
Change `project` and `region` in stages/demo/env.hcl to your GCP project name and region where you want to deploy the infrastructure. 
Or if you prefer, have to replicate the demo folder with another name and other parameters.

You have to run the infrastructure bootstrap with the following command.
```
$ cd stages/acme-demo/
$ terragrunt apply-all
```

This procedure also asks you if you have(or make) a remote GCS bucket over keep safe the terraform state, after that make up a GKE private cluster with an associate node pool(VM). The script has to deploy FluxCDv1 and Helm operator to flux namespace with a key secret after this.
At completed the procedure terragrunt should give you some information in the output, like in the following: 

```
...
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

flux_namespace = "flux"
google_access_token = "ya29.c.KqYB7gc5YBipkV1dgrnUkrGsxkHMZAjdjIJ05Gv4uZT2XXNsSSwOqQBqxvCxBoOIW90aiNvh2h0EVmIeDfil2RQ0mFnJN_4wmGR9wXlpj69SvxdXrnMbM_1kkDew9MMhiEFbbyqaUTFBQhFGLGPja9CDVX7DMfvzG6xdXKNQvaB1oD0WHn51vVvhkBixSh_bI3syvAff0Jg8vMZsX5sVpc7HWUB_hvQaFQ"
private_key_pem = (sensitive)
public_key_openssh = <<EOT
ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADE1Vl6ZX04vBt7zqM0LgK9yKKhkXKGiVswzsJDPYpNDAgmq+iAvhsqgnD6/20zesfQT3rbzzMC/JoTD28LPMiReQDbXEJVVvM1N5LZkSSImIjPmkAwxzMfoIkTMCAUMkcSRyzYNDysNWin+BpZEr4uDLSizkUcZqzPZ0mtE/MSa5veTQ==
EOT
```
Copy contents of public_key output: 
```
ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADE1Vl6ZX04vBt7zqM0LgK9yKKhkXKGiVswzsJDPYpNDAgmq+iAvhsqgnD6/20zesfQT3rbzzMC/JoTD28LPMiReQDbXEJVVvM1N5LZkSSImIjPmkAwxzMfoIkTMCAUMkcSRyzYNDysNWin+BpZEr4uDLSizkUcZqzPZ0mtE/MSa5veTQ==
```
Go to settings in your Github repo and Deploy keys, click Add deploy key button.
Paste the public key into the key text area and check. Allow write access.

Now all resources can be deployed. 

# Kubectl Control

## Kubectl environment
You have to generate the kubeconfig entries for manage the GKE cluster (pod, namespaces, stats etc.)

You made this through `gcloud beta container`, ensure if beta provider of gcloud is correctly updated in your machine. After this, you can configure kubectl with `gcloud container clusters get-credentials your-cluster-name --region region-of-your cluster`

```
$ gcloud container clusters get-credentials demo-kindone-cluster --region europe-north1-a

```

you can check if that works as well with a classic command like: 
```
$ kubectl cluster-info
```
and 
```
$ kubectl get ns
NAME              STATUS   AGE
default           Active   158m
flux              Active   122m
kube-node-lease   Active   158m
kube-public       Active   158m
kube-system       Active   158m
```

# Flux Control

## Flux environment 
You have to check if the flux rollout is completed and it's synced with the repo through the key you've applied in the repository, or some workload is stuck for some reason. Ensure if flux and fluxctl of gcloud are correctly updated in your machine.

One time you're ready, you can check if flux provider is reachable: 
```
$ flux check
```
Ensure workload status:
```
$ fluxctl list-workloads --k8s-fwd-ns flux
```

Ensure if flux is synced with repo and branch
```
$ fluxctl sync --k8s-fwd-ns flux
```
With a similar output
```
Synchronizing with ssh://git@github.com/Deepzima/gitops-dry-infrastructure.git
Revision of main to apply is e9b989c
Waiting for e9b989c to be applied ...
Done.
```

If all procedure are gone Ok, you can see a similar output:
```
$ kubectl get pods --all-namespaces

NAMESPACE     NAME                                                            READY   STATUS    RESTARTS   AGE
demo          podinfo-7599d75df-wxh8w                                         1/1     Running   0          2m45s
flux          flux-cfd66694-9q5ld                                             1/1     Running   0          4m58s
flux          flux-memcached-64f7865494-98zvc                                 1/1     Running   0          148m
flux          helm-operator-c5d675c57-nz5mf                                   1/1     Running   0          76m
kube-system   calico-node-vertical-autoscaler-6d6959f844-q8clm                1/1     Running   0          3h3m
kube-system   calico-node-wkn5b                                               1/1     Running   2          179m
kube-system   calico-typha-5754cbfbdd-47rv7                                   1/1     Running   0          179m
kube-system   calico-typha-horizontal-autoscaler-6bd9747b5b-z6g4g             1/1     Running   0          3h3m
kube-system   calico-typha-vertical-autoscaler-9d9fc75c5-kqsf4                1/1     Running   0          3h3m
kube-system   event-exporter-gke-666b7ffbf7-ptgqn                             2/2     Running   0          3h3m
kube-system   fluentbit-gke-zjtrl                                             2/2     Running   0          179m
kube-system   gke-metrics-agent-fhgt5                                         1/1     Running   0          179m
kube-system   ip-masq-agent-vv47f                                             1/1     Running   0          179m
kube-system   konnectivity-agent-b2t5p                                        1/1     Running   0          179m
kube-system   kube-dns-9c59558bb-qd8xq                                        4/4     Running   0          3h3m
kube-system   kube-dns-autoscaler-5c78d65cd9-vv66v                            1/1     Running   0          3h3m
kube-system   kube-proxy-gke-demo-kindone-cluster-node-pool-1-98f03965-1nz5   1/1     Running   0          179m
kube-system   l7-default-backend-5b76b455d-9clbf                              1/1     Running   0          3h3m
kube-system   metrics-server-v0.3.6-547dc87f5f-cw2bx                          2/2     Running   0          175m
kube-system   prometheus-to-sd-dk9cv                                          1/1     Running   0          179m
kube-system   stackdriver-metadata-agent-cluster-level-85d749dbbf-wxnsd       2/2     Running   5          179m
```


# Clean up

To wipe up all provisioned resources:

```
$ cd stages/acme-demo/
$ terragrunt destroy-all
```
