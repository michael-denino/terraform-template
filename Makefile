# For local development only.
VAR_FILE ?= ./envs/dev/dev.tfvars
BACKEND_CONFIG ?= ./envs/dev/backend-config.dev.tfvars

init:
	terraform init -backend-config=$(BACKEND_CONFIG)

plan apply destroy:
	terraform $@ -var-file=$(VAR_FILE)

.PHONY: init plan apply destroy
