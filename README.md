# Helm-Upcheck - A Helm Update Checker For Charts
![docker-image](https://github.com/orchit/helm-upcheck/actions/workflows/docker-image.yml/badge.svg)

Current version: **v1.0.0**

Helm-Upcheck uses nova to check the helm releases for updates. The updates are provided as text file and as prometheus metrics.

You can view them using the service "helm-upcheck" which provides http access to them. The following URLs are available:

- http://SERVICE/versions  - Displays the text output from nova that was used to create the metrics
- http://SERVICE/metrics   - Serves the prometheus metrics which include the update informations for the helm charts
- http://SERVICE/refresh   - Http endpoint to initiate a helm version check, this is called from a kubernetes cron job, by default every hour

To access the service on localhost:3080 you can use kube-proxy for example:

    kubectl port-forward service/helm-upcheck -n helmupcheck 3080:80

upcheck_helm_item contains information about individual releases. The value is 0 = ok, 1 = old, 2 = deprecated, 3 = old+deprecated

upcheck_helm_items_total, upcheck_helm_items_ok_total, upcheck_helm_items_old_total, upcheck_helm_items_deprecated_total show the summarized values for convinience

## Deployment

For deployment modify and apply the deployment.yaml and if you use the prometheus operator, you can also apply the servicemonitor.yaml, which also includes two rules for alerts.

If time permits we will also release a helm chart for it.
