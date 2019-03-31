#! /bin/bash

echo 'Creating reddit instance'

gcloud compute instances create reddit-app-full \
    --zone="europe-west1-b" \
    --boot-disk-size=15GB \
    --image reddit-full-1553977853 \
    --machine-type=f1-micro \
    --tags puma-server \
    --restart-on-failure
