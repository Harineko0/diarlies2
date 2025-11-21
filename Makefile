.PHONY: help install dev test lint format build clean ci
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RESET := \033[0m

##@ General

help: ## Display this help message
	@echo "$(BLUE)Diarlies Monorepo - Available Commands$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make $(GREEN)<target>$(RESET)\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2 } /^##@/ { printf "\n$(YELLOW)%s$(RESET)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Installation

install: install-web install-backend ## Install all dependencies
	@echo "$(GREEN)✓ All dependencies installed$(RESET)"

install-web: ## Install web (Next.js) dependencies
	@echo "$(BLUE)Installing web dependencies...$(RESET)"
	@cd apps/web && pnpm install

install-backend: ## Install backend (Go) dependencies
	@echo "$(BLUE)Installing backend dependencies...$(RESET)"
	@cd apps/backend && go mod download

install-terraform: ## Initialize Terraform
	@echo "$(BLUE)Initializing Terraform...$(RESET)"
	@cd apps/terraform && terraform init -backend=false

##@ Development

dev-web: ## Start web development server
	@echo "$(BLUE)Starting web dev server...$(RESET)"
	@cd apps/web && pnpm dev

dev-backend: ## Start backend development server
	@echo "$(BLUE)Starting backend dev server...$(RESET)"
	@cd apps/backend && go run ./cmd/api

dev: ## Start all development servers (requires multiple terminals)
	@echo "$(YELLOW)Note: This requires running in separate terminals$(RESET)"
	@echo "  Terminal 1: make dev-web"
	@echo "  Terminal 2: make dev-backend"

##@ Testing

test: test-web test-backend ## Run all tests
	@echo "$(GREEN)✓ All tests passed$(RESET)"

test-web: ## Run web tests
	@echo "$(BLUE)Running web tests...$(RESET)"
	@cd apps/web && pnpm test

test-web-watch: ## Run web tests in watch mode
	@cd apps/web && pnpm test:watch

test-backend: ## Run backend tests
	@echo "$(BLUE)Running backend tests...$(RESET)"
	@cd apps/backend && go test ./...

test-backend-verbose: ## Run backend tests with verbose output
	@cd apps/backend && go test -v ./...

##@ Code Quality

lint: lint-web lint-backend lint-terraform ## Run all linters
	@echo "$(GREEN)✓ All linting passed$(RESET)"

lint-web: ## Lint web code
	@echo "$(BLUE)Linting web...$(RESET)"
	@cd apps/web && pnpm lint

lint-backend: ## Lint backend code (go fmt check + go vet)
	@echo "$(BLUE)Linting backend...$(RESET)"
	@cd apps/backend && \
		if [ -n "$$(gofmt -l .)" ]; then \
			echo "$(YELLOW)gofmt needed on:$(RESET)"; \
			gofmt -l .; \
			exit 1; \
		fi && \
		go vet ./...

lint-terraform: ## Check Terraform formatting
	@echo "$(BLUE)Checking Terraform format...$(RESET)"
	@cd apps/terraform && terraform fmt -check -recursive

format: format-web format-backend format-terraform ## Format all code
	@echo "$(GREEN)✓ All code formatted$(RESET)"

format-web: ## Format web code
	@echo "$(BLUE)Formatting web...$(RESET)"
	@cd apps/web && pnpm format

format-backend: ## Format backend code
	@echo "$(BLUE)Formatting backend...$(RESET)"
	@cd apps/backend && gofmt -w .

format-terraform: ## Format Terraform files
	@echo "$(BLUE)Formatting Terraform...$(RESET)"
	@cd apps/terraform && terraform fmt -recursive

##@ Build

build: build-web build-backend ## Build all applications
	@echo "$(GREEN)✓ All applications built$(RESET)"

build-web: ## Build web application
	@echo "$(BLUE)Building web...$(RESET)"
	@cd apps/web && pnpm build

build-backend: ## Build backend binary
	@echo "$(BLUE)Building backend...$(RESET)"
	@cd apps/backend && go build -o ../../bin/api ./cmd/api
	@echo "$(GREEN)✓ Binary created at bin/api$(RESET)"

##@ Terraform

tf-validate: ## Validate Terraform configuration
	@echo "$(BLUE)Validating Terraform...$(RESET)"
	@cd apps/terraform && \
		terraform init -backend=false && \
		terraform validate

tf-plan: ## Run Terraform plan (requires backend config)
	@echo "$(BLUE)Running Terraform plan...$(RESET)"
	@cd apps/terraform && terraform plan

tf-apply: ## Apply Terraform changes (requires backend config)
	@echo "$(YELLOW)⚠ This will apply changes to your infrastructure$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd apps/terraform && terraform apply; \
	fi

##@ Firebase

firebase-deploy: ## Deploy to Firebase (hosting + firestore rules)
	@echo "$(BLUE)Deploying to Firebase...$(RESET)"
	@cd apps/firebase && firebase deploy

firebase-deploy-hosting: ## Deploy only Firebase hosting
	@cd apps/firebase && firebase deploy --only hosting

firebase-deploy-rules: ## Deploy only Firestore rules
	@cd apps/firebase && firebase deploy --only firestore:rules

##@ CI/CD

ci: ci-web ci-backend ci-terraform ## Run all CI checks locally
	@echo "$(GREEN)✓ All CI checks passed$(RESET)"

ci-web: ## Run web CI checks (lint, format, test, build)
	@echo "$(BLUE)Running web CI checks...$(RESET)"
	@cd apps/web && \
		pnpm install --no-frozen-lockfile && \
		pnpm lint && \
		pnpm format:check && \
		pnpm test && \
		pnpm build

ci-backend: ## Run backend CI checks (fmt, vet, test)
	@echo "$(BLUE)Running backend CI checks...$(RESET)"
	@cd apps/backend && \
		if [ -n "$$(gofmt -l .)" ]; then \
			echo "gofmt needed on:"; \
			gofmt -l .; \
			exit 1; \
		fi && \
		go vet ./... && \
		go test ./...

ci-terraform: ## Run Terraform CI checks (fmt, validate)
	@echo "$(BLUE)Running Terraform CI checks...$(RESET)"
	@cd apps/terraform && \
		terraform fmt -check -recursive && \
		terraform init -backend=false && \
		terraform validate

##@ Cleanup

clean: clean-web clean-backend clean-terraform ## Clean all build artifacts
	@echo "$(GREEN)✓ All artifacts cleaned$(RESET)"

clean-web: ## Clean web build artifacts
	@echo "$(BLUE)Cleaning web...$(RESET)"
	@cd apps/web && rm -rf .next node_modules

clean-backend: ## Clean backend build artifacts
	@echo "$(BLUE)Cleaning backend...$(RESET)"
	@rm -rf bin/
	@cd apps/backend && go clean

clean-terraform: ## Clean Terraform files
	@echo "$(BLUE)Cleaning Terraform...$(RESET)"
	@cd apps/terraform && rm -rf .terraform .terraform.lock.hcl

clean-all: clean ## Clean everything including dependencies
	@echo "$(BLUE)Deep cleaning...$(RESET)"
	@rm -rf node_modules pnpm-lock.yaml

##@ Utilities

check-deps: ## Check for outdated dependencies
	@echo "$(BLUE)Checking web dependencies...$(RESET)"
	@cd apps/web && pnpm outdated || true
	@echo "\n$(BLUE)Checking backend dependencies...$(RESET)"
	@cd apps/backend && go list -u -m all || true

update-deps: ## Update dependencies (use with caution)
	@echo "$(YELLOW)⚠ Updating dependencies...$(RESET)"
	@cd apps/web && pnpm update
	@cd apps/backend && go get -u ./... && go mod tidy
