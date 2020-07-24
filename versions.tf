/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  required_version = ">= 0.12"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.7"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.7"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 0.10"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.10"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.1"
    }
  }
}
