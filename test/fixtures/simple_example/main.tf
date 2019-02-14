/**
 * Copyright 2018 Google LLC
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

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = "${tls_private_key.main.private_key_pem}"
  filename = "${path.module}/sshkey"
}

 module "forseti-install-simple" {
   source = "../../../examples/simple_example"

  credentials_path   = "${var.credentials_path}"
  gsuite_admin_email = "${var.gsuite_admin_email}"
  project_id         = "${var.project_id}"
  org_id             = "${var.org_id}"
  domain             = "${var.domain}"

  instance_metadata {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}

resource "null_resource" "wait_for_server" {
  triggers = {
    server_instance_id = "${uuid()}"
  }

  provisioner "remote-exec" {
    inline = "while ! [ -f /etc/profile.d/forseti_environment.sh ]; do sleep 10; done"

    connection {
      user        = "ubuntu"
      host        = "${module.forseti-install-simple.forseti-server-vm-public-ip}"
      private_key = "${tls_private_key.main.private_key_pem}"
    }
  }
}

resource "null_resource" "wait_for_client" {
  triggers = {
    client_instance_id = "${uuid()}"
  }

  provisioner "remote-exec" {
    inline = "while ! [ -f /etc/profile.d/forseti_environment.sh ]; do sleep 10; done"

    connection {
      user        = "ubuntu"
      host        = "${module.forseti-install-simple.forseti-client-vm-public-ip}"
      private_key = "${tls_private_key.main.private_key_pem}"
    }
  }
}
