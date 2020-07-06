/**
 * Copyright 2019 Google LLC
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

#----------------#
# Forseti config #
#----------------#
variable "project_id" {
  description = "Google Project ID that you want Forseti deployed into"
}

#--------#
# Config #
#--------#
variable "suffix" {
  description = "The random suffix to append to all Forseti resources"
}

variable "services" {
  description = "An artificial dependency to bypass #10462"
  type        = list(string)
  default     = []
}

#----------------#
# Forseti bucket #
#----------------#
variable "storage_bucket_location" {
  description = "GCS storage bucket location"
  default     = "us-central1"
}

variable "storage_bucket_class" {
  description = "GCS storage bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE"
  default     = "STANDARD"
}

variable "bucket_cai_location" {
  description = "GCS CAI storage bucket location"
  default     = "us-central1"
}

variable "bucket_cai_lifecycle_age" {
  description = "GCS CAI lifecycle age value"
  default     = "14"
}

variable "gcs_labels" {
  description = "GCS bucket labels"
  type        = map(string)
  default     = {}
}

#-------#
# Flags #
#-------#
variable "enable_cai_bucket" {
  description = "Create a GCS bucket for CAI exports"
  type        = bool
  default     = true
}

