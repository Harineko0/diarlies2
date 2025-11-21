# Section 5: Terraform and Google Cloud Infrastructure

This section specifies the deployment and management strategy using Terraform for Infrastructure as Code (IaC).

## 1. Terraform Scope

Terraform will manage the provisioning, configuration, and state of all persistent Google Cloud resources.

| Resource Category | Managed Resources | Deployment Strategy |
| :--- | :--- | :--- |
| **Compute/Hosting** | Cloud Run Service (Go Backend) | Go service deployed as a container to Cloud Run for autoscaling and cost efficiency. |
| **AI Agents** | Vertex AI Endpoint/Service | Hosting the Python ADK application and configuring the Vertex AI Agent Builder components. |
| **Database** | Cloud SQL Instance (PostgreSQL) | Primary instance, network configuration, and initial database/user setup. |
| **Storage** | Cloud Storage Buckets | Bucket creation, IAM permissions, and versioning configuration. |
| **Networking** | VPC, Load Balancer (if necessary) | Basic networking setup. |
| **IAM** | Service Accounts, Permissions | Granting necessary access rights (e.g., Go Service Account needs access to Cloud SQL, Gemini APIs, and Cloud Storage). |

## 2. Infrastructure Design Decisions

### Scalability and Performance:
* **Go Backend:** Cloud Run provides serverless scaling and minimal operational overhead for the high-concurrency Go service.
* **AI Agent:** The AI Agent will be hosted on a service suitable for Python workloads (e.g., a GKE cluster or a dedicated Vertex AI endpoint/Cloud Run service) to efficiently manage the Python ADK.

### Cost and Security:
* **Database:** Cloud SQL is provisioned to automatically scale storage, ensuring high availability (HA) configuration for production.
* **IAM:** Principle of least privilege is enforced. Service Accounts are granted only the minimum required permissions to execute their specific tasks (e.g., the Go backend can only read/write to its own DB/Storage paths).
