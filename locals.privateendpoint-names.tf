// Preserve the existing default name when at most one endpoint is unnamed.
// For multiple unnamed endpoints, use a bounded, stable key-derived name.
// The hash distinguishes map keys that truncate or normalize identically.
locals {
  unnamed_private_endpoint_count = length([
    for endpoint in values(var.private_endpoints) : true
    if endpoint.name == null
  ])

  private_endpoint_names = {
    for key, endpoint in var.private_endpoints :
    key => endpoint.name != null ? endpoint.name : (
      local.unnamed_private_endpoint_count <= 1
      ? "pe-${var.name}"
      : "pep-${substr(var.name, 0, 36)}-${substr(lower(replace(key, "/[^0-9A-Za-z_-]/", "-")), 0, 10)}-${substr(sha1(key), 0, 12)}"
    )
  }
}
