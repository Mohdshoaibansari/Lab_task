AWS_ACCOUNT_ID ?= $(shell aws sts get-caller-identity --query Account --output text)
AWS_REGION = eu-central-1

DOCKER_TAG = {version}
ECR ?= ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
ECR_REPO ?= ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eks-repo


.PHONY: docker-registry-login
docker-registry-login:
	aws ecr get-login-password \
		--region ${AWS_REGION} \
	| docker login \
		--username AWS \
		--password-stdin ${ECR} 

.PHONY: docker-build
docker-build:
	cd Simple-flask-Example/; \
	docker build -t ${ECR_REPO}:${DOCKER_TAG} . ; \
	docker push $(ECR_REPO):${DOCKER_TAG}

.PHONY: docker-all
#docker-all: | docker-build docker-registry-login docker-push
docker-all: | docker-registry-login docker-build


.PHONY: docker-release
docker-release:
	aws ssm put-parameter \
		--name "/proxy/docker-image-uri" \
		--description "Current docker image of proxy container" \
		--type "String" \
		--value "$(ECR_REPO):$(DOCKER_TAG)" \
		--overwrite \
		--region $(AWS_REGION)


# .PHONY: docker-all
# #docker-all: | docker-build docker-registry-login docker-push
# docker-all: | docker-registry-login docker-pull docker-build docker-push
