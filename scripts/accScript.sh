#!/bin/bash

# Author: luciano.bastet@globant.com                        #
# This script replace raw_input for the owner email account #
# in the Forsety Security installer Script to automate      #
# the installation with Terraform                           #
  

sed -i '/self.config.gsuite_superadmin_email = raw_input(/c\\tself.config.gsuite_superadmin_email = '\"$1\"'' forseti-security/install/gcp/installer/forseti_server_installer.py
sed -i '/constants.QUESTION_GSUITE_SUPERADMIN_EMAIL).strip()/c\' forseti-security/install/gcp/installer/forseti_server_installer.py
