package policies

list = array.concat(_resources, _resource_properties)

_resources = [concat(".", [api, resource_type, policy]) |
    data.gcp[api][resource_type].policy[policy]
]

_resource_properties = [concat(".", [api, resource_type, property, policy]) |
    data.gcp[api][resource_type][property].policy[policy]
]
