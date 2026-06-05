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
        elif ! gcloud auth application-default print-access-token &>/dev/null; then
            echo "Please login to Application Default Credentials using: gcloud auth application-default login"
            exit 1
        elif [ ! -f "./config.env" ]; then
            echo "Error: config.env file not found."
            exit 1
        fi
        source ./config.env
        [ -n "${PROJECT_ID:-}" ] && export TF_VAR_project_id="$PROJECT_ID"
        [ -n "${REGION:-}" ] && export TF_VAR_region="$REGION"
        [ -n "${ZONE:-}" ] && export TF_VAR_zone="$ZONE"
        [ -n "${CLUSTER_NAME:-}" ] && export TF_VAR_cluster_name="$CLUSTER_NAME"
        (
            cd gke
            terraform init
            terraform plan
            terraform apply
            gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$ZONE" --project "$PROJECT_ID"
            echo "to delete run: ./start.sh -dg"
        )
        ;;
    dg|delete-gke)
        if [ ! -f "./config.env" ]; then
            echo "Error: config.env file not found."
            exit 1
        fi
        source ./config.env
        [ -n "${PROJECT_ID:-}" ] && export TF_VAR_project_id="$PROJECT_ID"
        [ -n "${REGION:-}" ] && export TF_VAR_region="$REGION"
        [ -n "${ZONE:-}" ] && export TF_VAR_zone="$ZONE"
        [ -n "${CLUSTER_NAME:-}" ] && export TF_VAR_cluster_name="$CLUSTER_NAME"
        (
            cd gke
            terraform destroy
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