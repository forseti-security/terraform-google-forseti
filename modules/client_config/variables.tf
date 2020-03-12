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

variable "forseti_home" {
  description = "Forseti installation directory"
  default     = "$USER_HOME/forseti-security"
}

variable "server_address" {
  description = "The Forseti server address"
}

#--------------------#
# Forseti client GCS #
#--------------------#
variable "client_enabled" {
  description = "Enable Client VM"
  default     = true
  type        = bool
}

variable "client_gcs_module" {
  description = "The Forseti Client GCS module"
}
