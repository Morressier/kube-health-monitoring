#! /bin/sh

get_deployments() {
  kubectl get deployment -o=jsonpath="{.items[*]['metadata.name']}"
}

get_available_pods() {
  kubectl get deployment "$1" -o=jsonpath="{.status.availableReplicas}"
}

hasNoAvailablePods() {
  available="$(get_available_pods "$1")"
  echo "Deployment $1 has $available available pods!"
  if [ -z "$available" ]; then
    return 0
  else
    return 1
  fi
}

readonly depl="$(get_deployments)"

for OUTPUT in ${depl}
do
   if hasNoAvailablePods "$OUTPUT"; then
     echo "Sleep 30 seconds and retry"
     sleep 30
     if hasNoAvailablePods "$OUTPUT"; then
       echo "Going to send alert for $OUTPUT to channel $CHANNEL"
       alert="Deployment $OUTPUT has no available pods!"
       curl -X POST --data-urlencode "payload={\"channel\": \"$CHANNEL\", \"username\": \"Kubernetes Health\", \"text\": \"$alert\", \"icon_emoji\": \":female-firefighter:\"}" "$WEBHOOK"
     fi
   fi
done


