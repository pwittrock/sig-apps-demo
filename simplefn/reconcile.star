def reconcile(items):

  value = ctx.resource_list["functionConfig"]["value"]
  for resource in items:
    resource["metadata"]["labels"]["fn-label"] = value

reconcile(ctx.resource_list["items"])
