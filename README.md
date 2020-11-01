# kube-health-monitoring
This is simple solution to monitor the health of your deplyoments in kuberenetes. It includes a cron job which will run 
every X minutes and check weather any of your deployments doesn't have running pods. If so it will send an alert message to slack.

### Deployment

Prerequisites
* kubectl 

First you need to create a configmap from the shell script. For that run
```bash
kubectl create configmap available-pods-check --from-file=available-pods-check.sh
```

Second we need to create cron job and service account for it. 
Please make sure to modify cron.yaml file and set the following env variables: 

* CHANNEL
* WEBHOOK (You can check [here](https://api.slack.com/messaging/webhooks) how to create Inbound Webhook for Slack)

Also you can change the schedule of cronjob which is set to run every 5 minutes.

After that go ahead and run 
```bash
kubectl apply -f cron.yaml
```
 
You can check that your cron has been created, and the last schedule by running
```bash
kubectl get cronjob available-pods-check
```

Stay healthy!
