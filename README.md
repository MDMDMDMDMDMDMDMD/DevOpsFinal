# DevOps Final Project - ToDo App
**Author:** MaxatD

## Overview
This project demonstrates a full DevOps lifecycle for a Spring Boot ToDo application, focusing on automation, security, and scalability.

## Architecture
- **App**: Spring Boot (Java 17) with Actuator for observability and Global Exception Handling for robustness.
- **Database**: PostgreSQL 15, chosen for reliability and ACID compliance.
- **Container**: Docker Multi-stage builds to minimize image size and `non-root` user for security.
- **CI/CD**: Jenkins Pipeline with dynamic tagging (`1.1.${BUILD_NUMBER}`) for traceability.
- **Orchestration**: Kubernetes with HPA (Horizontal Pod Autoscaler) for scalability under load.
- **IaC**: Ansible Roles for modular and reproducible infrastructure setup.

## DevOps Decisions & Rationale
1.  **Security**:
    - **Non-root container**: Prevents container breakout attacks.
    - **Secrets Management**: K8s Secrets and Ansible Vault (simulated) prevent hardcoding credentials in git.
    - **SSH Keys**: Passwordless login enforces stricter access control.
2.  **Scalability**:
    - **HPA**: Automatically scales pods based on CPU usage (target 50%).
    - **Stateless App**: Session state is avoided to allow easy scaling.
3.  **Automation & Reproducibility**:
    - **Ansible**: Idempotent playbooks ensure the environment is always in the desired state.
    - **Docker**: Ensures "works on my machine" translates to production.
    - **Jenkinsfile**: Pipeline-as-Code ensures the build process is versioned and reviewable.

## Setup Instructions

### 1. VM & Tools (Part 0)
Run the setup script to prepare the environment:
```bash
sudo ./scripts/setup_vm_MaxatD.sh
sudo ./scripts/configure_system_MaxatD.sh
```

### 2. Infrastructure (Part 4)
Deploy tools using Ansible:
```bash
cd ansible
ansible-playbook -i inventory playbook_MaxatD.yml
```

### 3. Deployment (Part 3)
If not deployed via Ansible, apply manually:
```bash
kubectl apply -f k8s/
```
Verify: `kubectl get pods`, `kubectl get hpa`.

## Naming Convention
All custom files utilize the suffix `_MaxatD`.
