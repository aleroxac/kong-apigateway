conf ?= .env
include $(conf)
export $(shell sed 's/=.*//' $(conf))

.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

up: ## Create network and run docker-compose files
	@docker network create kong-net
	@docker-compose -f composes/kong-compose.yml up -d
	@docker-compose -f composes/logging-compose.yml up -d
	@docker-compose -f composes/metrics-compose.yml up -d
	@docker-compose -f composes/services-compose.yml up -d

down: ## Delete network and containers remove containers created by docker-compose files
	@docker-compose -f composes/kong-compose.yml down
	@docker-compose -f composes/logging-compose.yml down
	@docker-compose -f composes/metrics-compose.yml down
	@docker-compose -f composes/services-compose.yml down
	@docker network rm kong-net
