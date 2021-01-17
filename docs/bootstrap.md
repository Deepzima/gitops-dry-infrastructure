# Setup the project 

## Service Account and IAM

First of all you have to register and download the Gcloud console and sdk. Once time we've made that we create a new project 
```
gcloud init
```


Afther that you need to create a Service Account and assign following roles and create a key:
  - Storage Admin
  - Kubernetes Engine Admin
  - Compute Admin
  - Service Account User


### Create the service account:
```
gcloud iam service-accounts create kindone-automation \
  --description "SA used for ${PROJECT} Actions" \
  --display-name "${PROJECT}-automation"
```
### Assign the owner role to the service account
```
gcloud projects add-iam-policy-binding ${PROJECT} \
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
Now you have to activate the service or export the kay for the console, in follow:
```
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json
```

or

```
gcloud auth activate-service-account --key-file ~/.config/gcloud/application_default_credentials.json
```


## Generate Github Deploy Key

You have to generate a custom key for flux deployments from github
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Copy private key file from `/.ssh/key_gen` to `stage/demo/flux/`

Copy contents of public key file `/.ssh/key_gen`. Go to settings in your Github repo and Deploy keys, click Add deploy key button.
Paste the public key into the key textarea and check Allow write access.


## Update Terraform Inputs
Change `project` and `region` in stages/demo/env.hcl to your gcp project name and region where you want to deploy the infrastructure. 
Or if you prefer, just have to replicate the demo folder with another name and others paramenters