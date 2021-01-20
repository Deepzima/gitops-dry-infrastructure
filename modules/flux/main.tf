locals {}


# ------------------------------------------------------------------------------
# MAKE UP A SECRET FOR FLUX 
# ------------------------------------------------------------------------------

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# resource "local_file" "key" {
#   filename = "../../key_flux"
#   content  = "${base64decode(tls_private_key.flux.private_key_pem)}"
# }


# ------------------------------------------------------------------------------
# DEPLOY FLUX 
# ------------------------------------------------------------------------------

resource "kubernetes_namespace" "flux_namespace" {
  metadata {
    name = var.flux_namespace
  }
}

resource "kubernetes_secret" "flux_git_deploy" {
  metadata {
    name      = "flux-ssh"
    namespace = var.flux_namespace
  }

  type = "Opaque"

  data = {
    identity = tls_private_key.flux.private_key_pem
  }

  depends_on = [kubernetes_namespace.flux_namespace]
}


resource "helm_release" "fluxcd" {
  name       = "flux"
  namespace  = var.flux_namespace
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  #force_update = "true"
  version = var.flux_chart_version
  wait    = true

  set {
    name  = "git.url"
    value = var.flux_git_repo
  }

  set {
    name  = "git.branch"
    value = var.flux_git_branch
  }

  set {
    name  = "git.path"
    value = join("\\,", var.flux_git_path)
  }

  set {
    name  = "git.pollInterval"
    value = var.flux_git_poll_interval
  }

  set {
    name  = "git.timeout"
    value = var.flux_git_timeout
  }

    set {
    name  = "manifestGeneration"
    value = "true"
  }


  set {
    name  = "git.secretName"
    value = kubernetes_secret.flux_git_deploy.metadata[0].name
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = var.flux_garbage_collection_enabled
  }


  values = [
    yamlencode({
      "additionalArgs" : [
        "--connect=ws://fluxcloud"
      ]
    })
  ]


  depends_on = [kubernetes_secret.flux_git_deploy]
}

resource "helm_release" "helm_operator" {
  name       = "helm-operator"
  namespace  = var.flux_namespace
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  #force_update = "true"
  version = var.flux_helm_operator_chart_version
  wait    = true

  # set {
  #   name  = "createCRD"
  #   value = var.create_crd
  # }

  set {
    name  = "helm.versions"
    value = var.helm_version
  }

  set {
    name  = "git.timeout"
    value = var.flux_git_timeout
  }

  set {
    name  = "git.secretName"
    value = kubernetes_secret.flux_git_deploy.metadata[0].name
  }


  depends_on = [kubernetes_secret.flux_git_deploy]
}