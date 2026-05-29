#!/bin/bash
cd "$(dirname "$0")"
read -p "kind(k) or gke(g) :" user_input

if [[ "$user_input" == "k" || "$user_input" == "kind" ]]
then
    kind create cluster --config=./kind/kind-config.yaml
    echo "to delete run: kind delete cluster"
elif [[ "$user_input" == "g" || "$user_input" == "gke" ]]
then
    PROJECT_ID=project-96345559-d949-4b8c-91b
    USER_IDENTIFIER=$(gcloud config get-value account)
    gcloud config set project $PROJECT_ID
    gcloud services enable container.googleapis.com
    for ROLE in "roles/container.admin" "roles/compute.networkAdmin" "roles/iam.serviceAccountUser"; do
        gcloud projects add-iam-policy-binding $PROJECT_ID --member="user:$USER_IDENTIFIER" --role=$ROLE
    done
    cd gke
    terraform init
    terraform plan
    terraform apply
    echo "to delete run: terraform destroy"
else
    echo "Invalid input! Please enter k or g."
fi