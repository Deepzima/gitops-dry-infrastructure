# Terraform Gke Flux Walkthrough

This repository is just a way for practice with Terraform and TerraGrunt in order to deploy a gke cluster and test many concept of GitOps for apps/services environment with Fluxcd.

## Introduction Scenario 
Acme, to dispose at well their solutions to the customers want to catch [bepbep](https://media.tenor.com/images/6e397fc371f5a93468c18cfc01e4bbaf/tenor.gif), has several environments (prod, staging and dev) entirely separated.

The infrastructure in each environment consists of multiple layers (gke, flux, vpc, ...) where each layer is configured using one of Terraform modules with arguments specified in `terragrunt.hcl` in layer's directory.

Terragrunt is used to work with Terraform configurations which allows orchestrating of dependent layers, update arguments dynamically and keep configurations DRY.


## Prerequisites

- Google Cloud Project

- [Terraform 0.12](https://www.terraform.io/intro/getting-started/install.html)
- [Terragrunt 0.22 or newer](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [Terraform Docs](https://github.com/segmentio/terraform-docs)

If you are using macOS you can install all dependencies using [Homebrew](https://brew.sh/):

    $ brew install terraform terragrunt pre-commit



### Project Structure

- `manifests` contains deployment manifest files e.g. kustomize, helm, k8s manifests.
   - app and service, example: podinfo service deployment manifests
- `stages` contains Terragrunt and Terraform configurations for each environment.
   - demo example environment contains module inputs
- `modules` contains reusable Terraform modules.
   - flux module for FluxCD and Helm operator
   - gke module to provision Kubernetes Engine and all resources needed by the cluster

## Quick start for create and managing your infrastructure
 After you've create a google service account, with the min permissions for manage and create via api the cluster. You have to Navigate through layers in `demo` .hcl files in order to review and customize values inside `inputs` block or values in env file.
 - After that, **Run this command to create infrastructure in all layers in a single region:**
```
$ cd stages/acme-demo/
$ terragrunt apply-all
```


## References

* [Terraform documentation](https://www.terraform.io/docs/) and [Terragrunt documentation](https://terragrunt.gruntwork.io/docs/) for all available commands and features.
* [Terraform AWS modules](https://github.com/terraform-aws-modules/).
* [Terraform modules registry](https://registry.terraform.io/).