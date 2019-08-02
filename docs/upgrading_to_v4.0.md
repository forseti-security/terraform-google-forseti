# Upgrading to v4.0

The v4.0 release of the *forseti* module is a backwards incompatible
release.

## Migration Instructions

This release is meant for use with Terraform 0.12. If you haven't upgraded and
need a Terraform 0.11.x-compatible version of this module, the last released
version intended for Terraform 0.11.x is 2.3.0.


### Inventory Email Summary

The `inventory_email_summary_enabled` field now has a default value of `false`,
instead of the previous default of `true`. It also now requires
`sendgrid_api_key` to be set to a non empty value. Without this Forseti will
not be able to successfully send emails. See
[forseti-security#3005](https://github.com/forseti-security/forseti-security/issues/3005).

To continue sending inventory summary emails, update a Terraform
configuration like the following example:

```diff
 module "forseti" {
   source  = "terraform-google-modules/forseti/google"
-  version = "~> 3.0"
+  version = "~> 4.0"

+  inventory_email_summary_enabled = "true"
+  sendgrip_api_key = "your-sendgrid-api-key-here"
   # ...
 }
```
