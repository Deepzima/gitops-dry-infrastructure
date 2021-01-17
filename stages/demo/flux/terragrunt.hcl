terraform {
  source = "../../../modules//flux"
}

include {
  path = find_in_parent_folders()
}

dependency "gke" {
  config_path = "../gke"
  mock_outputs = {
    cluster_endpoint        = "mock"
    cluster_ca_certificate  = ""
  }
}

inputs = {
  cluster_endpoint                  = dependency.gke.outputs.cluster_endpoint
  cluster_ca_certificate            = dependency.gke.outputs.cluster_ca_certificate
  flux_namespace                    = "flux"
  flux_chart_version                = "1.5.0"
  flux_helm_operator_chart_version  = "1.2.0"
  flux_garbage_collection_enabled   = "true"
  create_crd                        = "v3"
  flux_git_repo                     = "git@github.com:Deepzima/gitops-dry-infrastructure.git"
  flux_git_branch                   = "master"
  flux_git_path                     = ["mainfests", "mainfests/app", "manifests/podinfo"]
  flux_git_poll_interval            = "2m"
  flux_git_timeout                  = "1m"
}