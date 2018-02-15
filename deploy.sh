#!/usr/bin/env bash
set -x
set -e

echo "Deploying ${IMAGE_TAG} to hello-build-${CI_ENVIRONMENT_SLUG} for review/${CI_COMMIT_REF_NAME}"

jq < Dockerrun.aws.template.json ".Image.Name=\"${IMAGE_TAG}\""  > Dockerrun.aws.json
git add Dockerrun.aws.json

if [ ! -z "$(eb list | grep "${CI_ENVIRONMENT_SLUG}")" ]
then
    echo "Updating existing environment"
    eb deploy --staged "$CI_ENVIRONMENT_SLUG" | tee "$CIRCLE_ARTIFACTS/eb_deploy_output.txt"
else
    echo "Creating new environment"
    git config user.email "ci@example.org"
    git config user.name "CI"
    git commit -m "BS commit for BS eb CLI" # create lacks a --staged option
    eb create -c "hello-build-$CI_ENVIRONMENT_SLUG" "$CI_ENVIRONMENT_SLUG" | tee "$CIRCLE_ARTIFACTS/eb_deploy_output.txt"
fi

# Temporary hack to overcome issue eith 'eb deploy' returning exit code 0 on error
# See http://stackoverflow.com/questions/23771923/elasticbeanstalk-deployment-error-command-hooks-directoryhooksexecutor-py-p

if grep -c -q -i error: "$CIRCLE_ARTIFACTS/eb_deploy_output.txt"
then    
    echo 'Error found in deploy log.'
    exit 1
fi
