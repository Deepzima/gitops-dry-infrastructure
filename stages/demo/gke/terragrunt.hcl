terraform {
  source = "../../../modules//gke?ref=master"
}

include {
  path = find_in_parent_folders()
}

inputs = {

  # NETWORKING 
  vpc_cidr_block = "10.3.0.0/16"
  vpc_secondary_cidr_block  = "10.4.0.0/16"

  # CLUSTER PARTAMETERS
  name                             = "gitops-podinfo-demo"
  description                      = "GitOps PodInfo Demo"
  regional                         = false
  region                           = "europe-north1"
  zones                            = ["europe-north1-a"]
  #initial_node_count               = "1"
  #remove_default_node_pool         = true that is a standard move for gke-grunt
  logging_service                  = "logging.googleapis.com/kubernetes"
  monitoring_service               = "monitoring.googleapis.com/kubernetes" 
  master_ipv4_cidr_block           = "10.5.0.0/28"
  enable_private_nodes             = false
  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "Any"
    },
  ]
  
  http_load_balancing              = true
  enable_network_policy            = true
  enable_vertical_pod_autoscaling  = true
  enable_horizontal_pod_autoscaling  = true
  maintenance_start_time           = "19:00"
  issue_client_certificate         = true
  enable_workload_identity         = false

  # NODEPOOOLS PATAMETERS
  default_max_pods_per_node        = 64
  node_pools = [
    {
      name              = "node-pool-1"
      machine_type      = "n1-standard-4"
      autoscaling       = true
      min_count         = 1
      max_count         = 3
      disk_size_gb      = 30
      disk_type         = "pd-standard"
      image_type        = "COS"
      auto_repair       = false
      preemptible       = true
    }
  ]
  
  node_pools_tags = {
    node-pool-1 = ["gke-node"]
  }
  cluster_resource_labels = {
    maintained-by = "terraform"
  }
}