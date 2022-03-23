#!/bin/bash
DOCKER_IMAGE_NAME=jenkins-agent
DOCKER_TAG=$1

# Login to AWS ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 583117839140.dkr.ecr.us-east-1.amazonaws.com

if [ "$DOCKER_TAG" = "" ] ; then
    echo "Tag not explicitly specified - using latest"
    DOCKER_TAG="latest"
fi

docker build -t remarkety/$DOCKER_IMAGE_NAME:$DOCKER_TAG .

if [ $? -eq 0 ]; then
	docker tag remarkety/$DOCKER_IMAGE_NAME:$DOCKER_TAG 583117839140.dkr.ecr.us-east-1.amazonaws.com/remarkety/$DOCKER_IMAGE_NAME:$DOCKER_TAG
	if [ $? -eq 0 ]; then
		docker push 583117839140.dkr.ecr.us-east-1.amazonaws.com/remarkety/$DOCKER_IMAGE_NAME:$DOCKER_TAG
	else
		echo Failed to tag
	fi
else
    echo Failed to build
fi

