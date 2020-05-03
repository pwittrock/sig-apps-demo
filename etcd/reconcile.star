# TODO: make this find the right container, port, env rather than using the index
def reconcile(items):
  name = ctx.resource_list["functionConfig"]["metadata"]["name"]
  for resource in items:
    if resource["metadata"]["name"] != name:
      continue
    if  resource["kind"] != "StatefulSet":
      continue

    # calculate and set the initial cluster
    replicas = resource["spec"]["replicas"]
    serviceName = resource["spec"]["serviceName"]
    port = resource["spec"]["template"]["spec"]["containers"][0]["ports"][1]["containerPort"]

    # calculate the desired initial cluster value from the expected pods
    pods = ["{}-{}=http://{}-{}:{}".format(name, x, name, x, port) for x in range(replicas)]
    resource["spec"]["template"]["spec"]["containers"][0]["env"][1]["value"] = ",".join(pods)

reconcile(ctx.resource_list["items"])
