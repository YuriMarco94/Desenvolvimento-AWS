🚀 AWS EKS Platform - Plataforma de Desenvolvimento em Kubernetes
https://img.shields.io/badge/License-MIT-yellow.svg
https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white
https://img.shields.io/badge/AWS-FF9900?style=flat&logo=amazonaws&logoColor=white
https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white
https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white

📋 Visão Geral
AWS EKS Platform é uma solução completa de Infraestrutura como Código para provisionar e operar clusters Kubernetes na AWS com CI/CD automatizado, segurança nativa e observabilidade integrada.

🔗 Links Importantes:
- Repositório: https://github.com/YuriMarco94/Desenvolvimento-AWS
- GitHub Pages: https://yurimarco94.github.io/Desenvolvimento-AWS/
- GitHub Actions: https://github.com/YuriMarco94/Desenvolvimento-AWS/actions

🏗️ Arquitetura da Plataforma
┌─────────────────────────────────────────────────────────┐
│                    INFRAESTRUTURA AWS                   │
├─────────────────────────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │   VPC   │  │   EKS   │  │   ALB   │  │   ECR   │     │
│  │  3 AZs  │  │  v1.35  │  │   L7    │  │ Registry│     │
│  │ Private │  │ Managed │  │ Ingress │  │ Private │     │
│  │ Subnets │  │ Control │  │ Gateway │  │ Images  │     │
│  └────┬────┘  │  Plane  │  └────┬────┘  └────┬────┘     │
│       │       └────┬────┘       │            │          │
│       │            │            │            │          │
└───────┼────────────┼────────────┼────────────┼──────────┘
        │            │            │            │
        ▼            ▼            ▼            ▼
┌─────────────────────────────────────────────────────────┐
│                KUBERNETES PLATFORM                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │ Gateway │  │  Apps   │  │ Monitor │  │  Dash-  │     │
│  │  API    │  │ dev/hom/│  │-ing     │  │  board  │     │
│  │ + Envoy │  │  prod   │  │ Stack   │  │   UI    │     │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘     │
│       │            │            │            │          │
│       ▼            ▼            ▼            ▼          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │ HTTP/2  │  │ Echo    │  │ Metrics │  │ RBAC    │     │
│  │ TLS 1.3 │  │ Server  │  │ Logs    │  │ Auth    │     │
│  │ WAF     │  │ Demo    │  │ Traces  │  │ Audit   │     │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │
│                                                         │
├─────────────────────────────────────────────────────────┤
│              CI/CD AUTOMATION (GitHub)                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌─────────┐    ┌─────────┐    ┌─────────┐             │
│   │  DEV    │    │  HOM    │    │  PROD   │             │
│   │ Branch  │───▶│   PR    │───▶│  Merge │             │ 
│   │  Auto   │    │ Review  │    │ Approve │             │
│   │ Deploy  │    │  Gate   │    │ Manual  │             │
│   └─────────┘    └─────────┘    └─────────┘             │
│         │              │               │                │
│         ▼              ▼               ▼                │
│   ┌─────────┐    ┌─────────┐    ┌─────────┐             │
│   │ Build   │    │Security │    │ Canary  │             │
│   │ Test    │    │ Scan    │    │ Rollout │             │
│   │ Deploy  │    │ QA      │    │ Monitor │             │
│   └─────────┘    └─────────┘    └─────────┘             │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                 GOVERNANÇA & SEGURANÇA                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │Terraform│  │  RBAC   │  │ Network │  │ Secrets │     │
│  │ Modules │  │ Policies│  │ Policies│  │ Manager │     │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │
│                                                         │
│  ┌─────────┐  ┌──────────┐  ┌───────────┐  ┌─────────┐  │
│  │ Budgets │  │   Tags   │  │ Compliance│  │  OIDC   │  │
│  │ Alerts  │  │Chargeback│  │ CIS       │  │ GitHub  │  │
│  └─────────┘  └──────────┘  └───────────┘  └─────────┘  │
└─────────────────────────────────────────────────────────┘

📁 Estrutura do Projeto
DESENVOLVIMENTO-AWS/
├── .github/workflows/              # Pipelines CI/CD
│   ├── cd-dev.yaml                 # Deploy DEV automático
│   ├── cd-hom.yaml                 # Deploy HOM com gates
│   └── cd-prod.yaml                # Deploy PROD com aprovação
├── k8s/                            # Manifests Kubernetes
│   ├── addons/                     # Add-ons do cluster
│   │   ├── aws-load-balancer-controller/
│   │   ├── cluster-autoscaler/
│   │   ├── kube-prometheus-stack/
│   │   ├── kubernetes-dashboard/
│   │   └── metrics-server/
│   ├── apps/                       # Aplicações por ambiente
│   │   └── namespaces/
│   │       ├── dev/                # Ambiente de desenvolvimento
│   │       ├── hom/                # Ambiente de homologação
│   │       └── prod/               # Ambiente de produção
│   ├── gateway/                    # Gateway API configs
│   ├── gateway-api/                # CRDs e recursos Gateway
│   ├── platform/                   # Configurações da plataforma
│   └── rbac/                       # Roles e RoleBindings
└── terraform/                      # Infraestrutura como Código
    ├── modules/                    # Módulos reutilizáveis
    │   ├── eks/                    # Cluster EKS
    │   ├── network/                # VPC e subnets
    │   ├── ecr/                    # Container registry
    │   ├── rds/                    # Banco de dados
    │   └── security_baseline/      # Baseline de segurança
    └── envs/                       # Configurações por ambiente
        ├── dev/                    # Desenvolvimento
        ├── hom/                    # Homologação
        └── prod/                   # Produção

🔄 Workflow CI/CD
Desenvolvimento (DEV) - Deploy Automático
┌─────────┐       ┌─────────┐     ┌─────────┐       ┌─────────┐
│ Commit  │────▶ │ GitHub  │────▶│ Build   │────▶ │  Deploy │
│  to dev │      │ Actions │      │  Image  │       │ to EKS  │
└─────────┘      └─────────┘      └─────────┘       └─────────┘
     │               │               │               │
     │               │               │               │
     ▼               ▼               ▼               ▼
   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
   │  Code   │   │  OIDC   │   │  Push   │   │ Auto-   │
   │ Review  │   │  Auth   │   │  ECR    │   │ Tests   │
   └─────────┘   └─────────┘   └─────────┘   └─────────┘



Homologação (HOM) - Gates de Aprovação
┌─────────┐     ┌─────────┐     ┌─────────┐       ┌─────────┐
│   PR    │────▶│  Code   │────▶│ Manual  │────▶│ Deploy  │
│  to hom │     │ Review  │     │ Approve │       │ to EKS  │
└─────────┘     └─────────┘     └─────────┘       └─────────┘
                       │                              │
                       ▼                              ▼
                ┌─────────┐                    ┌─────────┐
                │Security │                    │   QA    │
                │ Scans   │                    │  Tests  │
                └─────────┘                    └─────────┘


Produção (PROD) - Aprovação Manual + Monitoramento
┌─────────┐     ┌─────────┐      ┌─────────┐       ┌─────────┐
│ Merge   │────▶│ GitHub  │────▶│  Prod   │────▶ │ Deploy  │
│ to main │     │ Actions │      │ Approve │       │ to EKS  │
└─────────┘     └─────────┘      └─────────┘       └─────────┘
                       │                              │
                       ▼                              ▼
                ┌─────────┐                    ┌─────────┐
                │ Final   │                    │Monitor &│
                │ Security│                    │Rollback │
                │ Checks  │                    │  Logic  │
                └─────────┘                    └─────────┘


🛡️ Security Framework
┌─────────────────────────────────────────────────────────┐
│                 SECURITY SHIFT-LEFT                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐              │
│  │   SAST  │    │   SCA   │    │   DAST  │              │
│  │  Code   │    │  Deps   │    │ Runtime │              │
│  │ Scanning│    │ Scanning│    │ Scanning│              │
│  └─────────┘    └─────────┘    └─────────┘              │
│         │              │               │                │
│         ▼              ▼               ▼                │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐              │
│  │ Semgrep │    │ Trivy   │    │  ZAP    │              │
│  │ Bandit  │    │ Grype   │    │ Proxy   │              │
│  │ SonarQube│   │ Snyk    │    │ Burp    │              │
│  └─────────┘    └─────────┘    └─────────┘              │
│                                                         │
├─────────────────────────────────────────────────────────┤
│              RUNTIME SECURITY & COMPLIANCE              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │ Network │  │  Pod    │  │ Secrets │  │  RBAC   │     │
│  │Policies │  │Security │  │ Rotation│  │ Auditing│     │
│  │ Calico  │  │ Podman  │  │ Vault   │  │  OPA    │     │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │
│                                                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │  CIS    │  │  SOC2   │  │  GDPR   │  │  HIPAA  │     │
│  │Benchmark│  │  Type2  │  │  Ready  │  │  Ready  │     │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │
└─────────────────────────────────────────────────────────┘


📊 Aplicação Demo - Echo Server
┌─────────────────────────────────────────────────────────┐
│                  APLICAÇÃO POR AMBIENTE                 │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  AMBIENTE   NAMESPACE  RÉPLICAS  ENDPOINT    PROTOCOLO  │
│  ─────────────────────────────────────────────────────  │
│                                                         │
│    DEV        dev         2      /echo-dev     HTTP     │
│              ┌────┐     ┌───┐   ┌────────┐   ┌─────┐    │
│              │Test│     │🟢 │   │Fast    │   │Port │    │
│              │Fast│     │ 🟢│   │Iterate │   │ 80  │    │
│              └────┘     └───┘   └────────┘   └─────┘    │
│                                                         │
│    HOM        hom         2      /echo-hom     HTTP     │
│              ┌────┐     ┌───┐   ┌────────┐   ┌─────┐    │
│              │QA  │     │ 🟡│   │Staging │   │Port │    │
│              │Gate│     │ 🟡│   │Preview │   │ 80  │    │
│              └────┘     └───┘   └────────┘   └─────┘    │
│                                                         │
│    PROD       prod        3      /echo-prod    HTTPS    │
│              ┌────┐     ┌───┐   ┌────────┐   ┌─────┐    │
│              │Prod│     │ 🔴│   │Canary  │   │Port │    │
│              │ SLA│     │ 🔴│   │Rollout │   │ 443 │    │
│              └────┘     │ 🔴│   └────────┘   └─────┘    │
│                         └───┘                           │
└─────────────────────────────────────────────────────────┘

Comandos para verificar:
# Verificar todos os ambientes
kubectl get pods -n dev
kubectl get pods -n hom  
kubectl get pods -n prod

# Verificar serviços
kubectl get svc -n dev echo
kubectl get svc -n hom echo
kubectl get svc -n prod echo

# Verificar ingress
kubectl get ingress -A | grep echo

