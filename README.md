# Terraform Template
Repository template for Terraform projects.

## Table of Contents
- [Overview](#overview)
- [Pre-Commit](#pre-commit)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
  - [Terraform-Docs](#terraform-docs)
  - [TFLint](#tflint)
- [Semantic-Release](#semantic-release)
- [Dependabot](#dependabot)
- [Environments](#environments)
- [Reusable Modules](#reusable-modules)
- [Additional Resources](#additional-resources)

## Overview
This repository template provides a starting point for common Terraform projects. It includes placeholder `.tf` files, .gitignore, pre-commit configuration, a semantic-release workflow, linting, and automated documentation generation. This README provides basic guidance for using the tools included in this template. References to Terraform documentation and best practices are also included.

## Pre-Commit
Pre-Commit uses the pre-commit Git hook to run tests prior to making a commit. The `.pre-commit-config.yaml` file included in this repository is configured for Terraform projects. The pre-commit configuration file references scripts located in external repositories. Modify the configuration as needed. Refer to the [pre-commit](https://pre-commit.com/) documentation for more information.

### Prerequisites
The following packages are required to use the pre-commit configuration specified in `.pre-commit-config.yaml`.
```zsh
brew install \
pre-commit \
terraform \
terraform-docs \
tflint
```

### Usage
Install the prerequisites listed in the [Prerequisites](#prerequisites) section. After cloning this repository to a workstation, enable pre-commit from the root of this repository:
```zsh
pre-commit install
```
Pre-Commit will add a Git hook to `.git/hooks/pre-commit`. The Git hook will trigger pre-commit when making commits to the repository. To manually trigger pre-commit, run:
```zsh
pre-commit run --all
```
To manually trigger individual tests, reference the hook id from `.pre-commit-config.yaml` and run:
```zsh
pre-commit run <hook_id>
```
By default, failing pre-commit tests will prevent a commit from being made. It can be useful to run pre-commit before attempting to make a commit as some pre-commit tests will automatically take remediating action. If a test that takes remediating action fails, the test should succeed on the next run if the remediating action was successful.
```zsh
$ pre-commit run trailing-whitespace
trim trailing whitespace.................................................Failed
- hook id: trailing-whitespace
- exit code: 1
- files were modified by this hook

Fixing README.md
```
```zsh
$ pre-commit run trailing-whitespace
trim trailing whitespace.................................................Passed
```
External repositories defined in `.pre-commit-config.yaml` are version pinned. To update versions in `.pre-commit-config.ymal`, run:
```zsh
pre-commit autoupdate
```

The `.github/workflows/pre-commit.yaml` workflow runs pre-commit in GitHub Actions when a pull request is created or updated. Running pre-commit in a GtiHub Actions workflow ensures that pre-commit runs even when it is not installed on a workstation. Add the pre-commit workflow as a required [status check](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks) in a GitHub [branch protection rule](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule) to ensure pre-commit tests pass before a pull request is merged.

### Terraform-Docs
Add the markers described in the [terraform_docs](https://github.com/antonbabenko/pre-commit-terraform#terraform_docs) section of the [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform#table-of-content) script documentation to `README.md`. Terraform-Docs will automatically generate Terraform documentation inside the markers. Markers can also be added to `README.md` files in subdirectories if local modules are used.

The markers used by the pre-commit script differ from the default markers used by [terraform-docs](https://github.com/terraform-docs/terraform-docs/#readme).

### TFLint
TFLint is a framework for linting Terraform providers.
`.tflint.hcl` contains the default configuration for running `tflint` against the AWS Terraform provider. Refer to the [TFLint](https://github.com/terraform-linters/tflint#readme) documentation for more information.

## Semantic-Release
The `.github/workflows/relase.yaml` workflow uses semantic-release to create [semantic versioning](https://semver.org/) GitHub releases. The semantic-release workflow is configured to trigger on push (merge) to the `main` branch.

Semantic-Release uses the [Angular Commit Message Format](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format) to create and format releases. Refer to the [semantic-release](https://github.com/semantic-release/semantic-release#readme) documentation for more information.

Semantic versioned releasees may not be necessary for Terraform root modules but should be used when creating reusable Terraform modules.

## Dependabot
A Dependabot configuration file is located at `./github/dependabot.yaml`. Dependabot is GitHub's automated dependency management tool that monitors dependencies for updates, security vulnerabilities, and compatibility issues. Dependabot automatically creates pull requests to update the dependencies specified in `dependabot.yaml`. Refer to the [Dependabot QuickStart Guide](https://docs.github.com/en/code-security/getting-started/dependabot-quickstart-guide) for more information.

## Environments
Modify files in the `./envs` directory to manage multiple environments. For example, to add a production backend configuration and production environment variables modify `./envs/prod/backend-config.prod.tfvars` and `./envs/prod/prod.tfvars`. The `Makefile` should be used for local development only. Use native CI/CD tooling to reference files in `./envs` when running CI/CD workflows. Do not include sensitive information in variable files.

## Reusable Modules
Remove `provider.tf` and `backend.tf` when using this repository template to create a reusable Terraform module. Providers and remote backends should only be defined in root modules. To test a reusable module, create a `./test` directory in the root of this repository and call the module from the test directory. Move the `Makefile` and `./envs` directory into the `test` directory. Reference the module using a relative path. Alternatively, the module can be referenced and tested from outside this repository.
```zsh
rm provider.tf backend.tf
mkdir test
mv Makefile ./test/Makefile
mv ./envs ./test/envs
touch ./test/main.tf
```
The following is an example test configuration. Add a remote backend definition if needed.
```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.56.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "example" {
  source = "../"
}
```

## Additional Resources
- [AWS Best Practices for Terraform](https://aws-ia.github.io/standards-terraform/)
- [Google Best Practices for Terraform](https://cloud.google.com/docs/terraform/best-practices-for-terraform)
- [Provider Plugin Cache](https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache)
- [Sharing Data Between Configurations](https://developer.hashicorp.com/terraform/language/state/remote-state-data#alternative-ways-to-share-data-between-configurations)
