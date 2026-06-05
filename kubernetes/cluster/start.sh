#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

user_input="${1:-}"
if [[ -z "$user_input" ]]; then
    read -p "Choose kind (k) or gke (g): " user_input
fi

case "$user_input" in
    k|kind)
        if ! command -v kind &> /dev/null; then
            echo "kind is not installed"
            exit 1
        elif ! docker info &> /dev/null; then
            echo "Error: Docker daemon is not running. Please start Docker." >&2
            exit 1
        fi
        kind create cluster --config=./kind/kind-config.yaml
        echo "to delete run: kind delete cluster"
    ;;
    g|gke)
        if ! command -v gcloud &> /dev/null; then
            echo "gcloud is not installed"
            exit 1
        elif ! command -v terraform &> /dev/null; then
            echo "terraform is not installed"
            exit 1
        elif [ -z "$(gcloud config get-value account)" ]; then
            echo "please login to gcloud using: gcloud auth login"
            exit 1
        fi
        USER_IDENTIFIER=$(gcloud config get-value account)
        PROJECT_ID="${PROJECT_ID:-project-96345559-d949-4b8c-91b}"
        gcloud config set project $PROJECT_ID
        gcloud services enable container.googleapis.com
        for ROLE in "roles/container.admin" "roles/compute.networkAdmin" "roles/iam.serviceAccountUser"; do
            gcloud projects add-iam-policy-binding $PROJECT_ID --member="user:$USER_IDENTIFIER" --role=$ROLE
        done
        (
            cd gke
            terraform init
            terraform plan
            terraform apply
            echo "to delete run: terraform destroy"
        )
        ;;
    -h|--help)
        echo "Usage: ./start.sh [k|g]"
        echo "k - kind"
        echo "g - gke"
        exit 0
    ;;
    *)
        echo "Error: Invalid input '$user_input'" >&2
        exit 1
    ;;
esac