# Troubleshoot 
In this section are described some issues can appearing during the bootstrap of the project.


## Gcloud 
- If you use a new GPC Account and you set your or another owner/role account for the project, the procedure can throw itself in error because Cloud Resource Manager API has not been enabled in the project. Make sure the project you created has this enabled or make it by visiting: https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=YOURPROJECTID then retry. If you enabled this API recently, wait a few minutes for the action to propagate to the systems and retry.

## Terragrunt 
- Nothing here for now.

## Flux
- Nothing here for now.