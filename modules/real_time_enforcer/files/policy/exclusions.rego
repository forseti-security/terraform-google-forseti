package exclusions

#
# Function to test if a resource label is present that marks the resource for exclusion
# Exclusion labels should be defined in _data.config.exclusion.labels_ in your config.yaml file
#
# Example config:
#
# ---
# config:
#   exclusions:
#     labels:
#       forseti-enforcer: disable
label_exclude(res_labels) {
  res_labels[key] == data.config.exclusions.labels[key]
}
