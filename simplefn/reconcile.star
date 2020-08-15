def reconcile(items):
  for resource in items:
    resource["metadata"]["annotations"]["fn-annotation"] = "set"

reconcile(ctx.resource_list["items"])
