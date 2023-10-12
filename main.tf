terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
  }
}

locals {
  match_labels = merge({
    "app.kubernetes.io/instance" = "drone"
    "app.kubernetes.io/name"     = "drone-server"
  }, var.match_labels)
  labels = merge(local.match_labels, {
    "app.kubernetes.io/version" = var.image_tag
  }, var.labels)
}

resource "kubernetes_service_account" "drone_server" {
  metadata {
    name      = "drone-server"
    namespace = var.namespace
    labels    = local.labels
  }
}

resource "kubernetes_deployment" "drone_server" {
  metadata {
    name      = "drone-server"
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.match_labels
    }
    template {
      metadata {
        labels = local.labels
        annotations = {
          "ravianand.me/config-hash" = sha1(jsonencode(merge(
            kubernetes_config_map.drone_server.data,
            kubernetes_secret.drone_server.data
          )))
        }
      }
      spec {
        service_account_name = kubernetes_service_account.drone_server.metadata.0.name
        container {
          image             = var.image_registry == "" ? "${var.image_repository}:${var.image_tag}" : "${var.image_registry}/${var.image_repository}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy
          name              = "drone"
          env_from {
            config_map_ref {
              name = kubernetes_config_map.drone_server.metadata.0.name
            }
          }
          env {
            name = "DRONE_GITEA_CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name     = kubernetes_secret.drone_server.metadata.0.name
                key      = "gitea-secret"
                optional = true
              }
            }
          }
          env {
            name = "DRONE_RPC_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.drone_server.metadata.0.name
                key  = "rpc-secret"
              }
            }
          }
          env {
            name = "DRONE_DATABASE_DATASOURCE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.drone_server.metadata.0.name
                key  = "database-url"
              }
            }
          }
          env {
            name = "DRONE_DATABASE_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.drone_server.metadata.0.name
                key  = "database-secret"
              }
            }
          }
          port {
            name           = "http"
            container_port = 80
            protocol       = "TCP"
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }
          }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }
          }
          resources {}
        }
      }
    }
  }
}

resource "kubernetes_service" "drone_server" {
  metadata {
    name      = "drone-server"
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    selector = local.match_labels
    type     = "ClusterIP"
    port {
      port        = 80
      name        = "http"
      target_port = "http"
    }
  }
}

resource "random_id" "rpc_secret_key" {
  byte_length = 16
}

resource "random_id" "database_secret_key" {
  byte_length = 16
}

resource "kubernetes_secret" "drone_server" {
  metadata {
    name      = "drone-server"
    namespace = var.namespace
  }
  data = {
    "database-url"    = var.drone_database_datasource
    "rpc-secret"      = random_id.rpc_secret_key.hex
    "database-secret" = random_id.database_secret_key.hex
    "gitea-secret"    = var.drone_gitea_secret
  }
}

resource "kubernetes_config_map" "drone_server" {
  metadata {
    name      = "drone-server-env"
    namespace = var.namespace
  }

  data = {
    DRONE_SERVER_HOST         = var.drone_host
    DRONE_SERVER_PROTO        = var.drone_proto
    DRONE_SERVER_PORT         = ":80"
    DRONE_USER_CREATE         = "username:${var.drone_admin},admin:true"
    DRONE_USER_FILTER         = var.drone_user_filter
    DRONE_REGISTRATION_CLOSED = var.drone_registration_closed
    DRONE_GITEA_SERVER        = var.drone_gitea_url
    DRONE_GITEA_CLIENT_ID     = var.drone_gitea_client
    DRONE_DATABASE_DRIVER     = var.drone_database_driver
    DRONE_S3_BUCKET           = var.drone_s3_bucket
    DRONE_S3_ENDPOINT         = var.drone_s3_endpoint
    DRONE_S3_PATH_STYLE       = var.drone_s3_path_style
    DRONE_S3_PREFIX           = var.drone_s3_prefix
    AWS_ACCESS_KEY_ID         = var.drone_s3_access_key
    AWS_SECRET_ACCESS_KEY     = var.drone_s3_secret_key
    AWS_DEFAULT_REGION        = var.drone_s3_default_region
    AWS_REGION                = var.drone_s3_region
    DRONE_STARLARK_ENABLED    = var.drone_starlark_enabled
    DRONE_WEBHOOK_ENDPOINT    = var.drone_webhook_endpoint
    DRONE_WEBHOOK_EVENTS      = var.drone_webhook_events
    DRONE_WEBHOOK_SECRET      = var.drone_webhook_secret
    DRONE_WEBHOOK_SKIP_VERIFY = var.drone_webhook_skip_verify
  }
}
