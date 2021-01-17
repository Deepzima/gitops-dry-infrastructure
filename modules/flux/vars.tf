
variable "project" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "cluster_endpoint" {
  type        = string
  description = "Cluster endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "Cluster CA certificate"
}

variable "flux_namespace" {
  type        = string
  description = "Flux namespace"
  default     = "flux"
}

variable "fluxcloud_chart_verion" {
  default = "0.1.2"
}

variable "flux_helm_operator_chart_version" {
  default     = "1.2.0"
  description = "Flux helm operator chart version  https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator"
}

variable "flux_chart_version" {
  default     = "1.5.0"
  description = "Flux chart version https://github.com/fluxcd/flux/tree/master/chart"
}

variable "flux_garbage_collection_enabled" {
  default = "true"
}

variable "create_crd" {
  description = "The version of the helm chart"
  default     = "true"
}

variable "helm_version" {
  description = "The version of the helm chart"
  default     = "v3"
}

#--- GIT VALUES

variable "flux_git_repo" {
  type        = string
  description = "URL of git repo"
}

variable "flux_git_branch" {
  type        = string
  description = "Branch of git repo"
  default     = "master"
}

variable "flux_git_path" {
  type        = list(string)
  description = "Path within git repo to locate Kubernetes manifests (relative path)"
}

variable "flux_git_timeout" {
  default = "5m"
}

variable "flux_git_poll_interval" {
  description = "Period at which to fetch any new commits from the git repo"
  default     = "1m"
}
