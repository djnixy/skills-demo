generate_hcl "_terramate_generated_helm.tf" {
  content {
    resource "random_password" "nikiakbar_password" {
      length  = 16
      special = false
    }

    resource "helm_release" "argocd" {
      name             = "argocd"
      repository       = "https://argoproj.github.io/argo-helm"
      chart            = "argo-cd"
      version          = "10.3.0"
      namespace        = "argocd"
      create_namespace = true

      values = [
        yamlencode({
          global = {
            domain = "argocd.nikiakbar.com"
          }

          configs = {
            cm = {
              "accounts.automation"                   = "login"
              "accounts.devops"                       = "login"
              "accounts.nikiakbar"                    = "login,apiKey"
              "admin.enabled"                         = "true"
              "application.instanceLabelKey"          = "argocd.argoproj.io/instance"
              "application.sync.impersonation.enabled" = "false"
              "exec.enabled"                          = "true"
              "server.rbac.log.enforce.enable"        = "false"
              "statusbadge.enabled"                   = "true"
              "timeout.hard.reconciliation"           = "0s"
              "timeout.reconciliation"                = "30s"
              url                                     = "https://argocd.nikiakbar.com"
            }

            secret = {
              extra = {
                "accounts.nikiakbar.password" = bcrypt(random_password.nikiakbar_password.result)
              }
            }

            params = {
              "server.insecure" = true
            }

            rbac = {
              "policy.csv" = <<-EOT
                # Full admin role
                p, role:admin, *, *, *, allow

                # Sync-only role (manual sync only)
                p, role:sync-only, applications, get, *, allow
                p, role:sync-only, applications, sync, *, allow
                p, role:sync-only, applications, override, *, allow

                # Assign users to roles
                g, nikiakbar, role:admin
                g, devops, role:admin
                g, automation, role:sync-only
              EOT
              "policy.default" = "role:readonly"
              scopes           = "[groups]"
            }
          }

          controller = {
            resources = {
              requests = {
                cpu    = "1000m"
                memory = "2.5Gi"
              }
              limits = {
                cpu    = "1000m"
                memory = "2.5Gi"
              }
            }
          }

          repoServer = {
            resources = {
              requests = {
                cpu    = "200m"
                memory = "256Mi"
              }
              limits = {
                cpu    = "200m"
                memory = "256Mi"
              }
            }
          }

          server = {
            ingress = {
              annotations = {
                "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
              }
              enabled          = true
              hostname         = "argocd.nikiakbar.com"
              ingressClassName = "traefik"
              tls = [
                {
                  secretName = "argocd-server-tls"
                  hosts      = ["argocd.nikiakbar.com"]
                }
              ]
            }
            resources = {
              requests = {
                cpu    = "100m"
                memory = "256Mi"
              }
              limits = {
                cpu    = "100m"
                memory = "256Mi"
              }
            }
          }

          dex = {
            resources = {
              requests = {
                cpu    = "100m"
                memory = "256Mi"
              }
              limits = {
                cpu    = "100m"
                memory = "256Mi"
              }
            }
          }

          applicationSet = {
            resources = {
              requests = {
                cpu    = "100m"
                memory = "128Mi"
              }
              limits = {
                cpu    = "100m"
                memory = "128Mi"
              }
            }
          }

          notifications = {
            resources = {
              requests = {
                cpu    = "100m"
                memory = "256Mi"
              }
              limits = {
                cpu    = "100m"
                memory = "256Mi"
              }
            }
          }

          redis = {
            resources = {
              requests = {
                cpu    = "100m"
                memory = "128Mi"
              }
              limits = {
                cpu    = "100m"
                memory = "128Mi"
              }
            }
          }
        })
      ]
    }

  }
}