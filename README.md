🚀 AWS EKS Platform - Plataforma de Desenvolvimento em Kubernetes

📋 Visão Geral
AWS EKS Platform é uma solução completa de infraestrutura como código (IaC) para provisionar e gerenciar clusters Kubernetes na AWS, projetada para ambientes de desenvolvimento, homologação e produção com governança, segurança e observabilidade integradas.

🏗️ Arquitetura da Plataforma
graph TB
    subgraph "Infraestrutura AWS"
        VPC[VPC com 3 AZs]
        EKS[Cluster EKS v1.35]
        ALB[Application Load Balancer]
        ECR[ECR Registry]
        RDS[RDS PostgreSQL]
    end
    
    subgraph "Kubernetes Platform"
        GatewayAPI[Gateway API + Envoy]
        Apps[Applications<br/>dev/hom/prod]
        Monitoring[Monitoring Stack<br/>Prometheus/Grafana]
        Dashboard[Kubernetes Dashboard]
        Autoscaler[Cluster Autoscaler]
    end
    
    subgraph "CI/CD Pipeline"
        GitHub[GitHub Actions]
        OIDC[AWS OIDC]
        SecurityScan[Security Scanning]
        Deploy[Deployment Automation]
    end
    
    subgraph "Governança"
        Terraform[Terraform Modules]
        Policies[Security Policies]
        Budgets[FinOps Budgets]
        Tagging[Resource Tagging]
    end
    
    VPC --> EKS
    EKS --> GatewayAPI
    EKS --> Apps
    EKS --> Monitoring
    EKS --> Dashboard
    
    GitHub --> OIDC --> EKS
    GitHub --> SecurityScan --> ECR
    GitHub --> Deploy --> Apps
    
    Terraform --> VPC
    Terraform --> EKS
    Terraform --> ALB
    Policies --> EKS
    Budgets --> VPC
    Tagging --> ALL[All Resources]

🎯 Funcionalidades Principais

✅ Infraestrutura como Código
- Módulos Terraform reutilizáveis (VPC, EKS, ECR, RDS)
- Estados remotos com S3 + DynamoDB
- Configuração multi-ambiente (dev/hom/prod)
- Tags consistentes para FinOps    

✅ Segurança Shift-Left
- Integração OIDC com GitHub Actions (sem secrets estáticos)
- Scanning de imagens com Trivy/Aquasec
- SAST/SCA/DAST nos pipelines
- Políticas de rede zero-trust
- Secrets management com AWS Secrets Manager

✅ Observabilidade Completa
- Prometheus Stack com Grafana
- Dashboard Kubernetes com RBAC
- Logs centralizados com CloudWatch
- Métricas customizadas para aplicações
- Alertas com Prometheus Alertmanager

✅ CI/CD Automatizado
- Pipelines por ambiente (dev → hom → prod)
- Deployment blue-green com Gateway API
- Rollback automático em falhas
- Gates de aprovação manuais para produção
- Notificações no Slack/Teams

📁 Estrutura do Projeto
DESENVOLVIMENTO-AWS/
├── .github/workflows/              # Pipelines CI/CD
│   ├── cd-dev.yaml                 # Deploy DEV automático
│   ├── cd-hom.yaml                 # Deploy HOM com gates
│   └── cd-prod.yaml               # Deploy PROD com aprovação
├── k8s/                           # Manifests Kubernetes
│   ├── addons/                    # Add-ons do cluster
│   │   ├── aws-load-balancer-controller/
│   │   ├── cluster-autoscaler/
│   │   ├── kube-prometheus-stack/
│   │   ├── kubernetes-dashboard/
│   │   └── metrics-server/
│   ├── apps/                      # Aplicações por ambiente
│   │   └── namespaces/
│   │       ├── dev/               # Ambiente de desenvolvimento
│   │       ├── hom/               # Ambiente de homologação
│   │       └── prod/              # Ambiente de produção
│   ├── gateway/                   # Gateway API configs
│   ├── gateway-api/               # CRDs e recursos Gateway
│   ├── platform/                  # Configurações da plataforma
│   └── rbac/                      # Roles e RoleBindings
└── terraform/                     # Infraestrutura como Código
    ├── modules/                   # Módulos reutilizáveis
    │   ├── eks/                   # Cluster EKS
    │   ├── network/               # VPC e subnets
    │   ├── ecr/                   # Container registry
    │   ├── rds/                   # Banco de dados
    │   └── security_baseline/     # Baseline de segurança
    └── envs/                      # Configurações por ambiente
        ├── dev/                   # Desenvolvimento
        ├── hom/                   # Homologação
        └── prod/                  # Produção

🔄 Workflow de Desenvolvimento

Desenvolvimento (DEV)
graph LR
    Dev[Commit na branch dev] --> GH[GitHub Actions]
    GH --> Build[Build Docker Image]
    Build --> Push[Push para ECR]
    Push --> Deploy[Deploy para EKS DEV]
    Deploy --> Test[Testes Automatizados]

Homologação (HOM)
graph LR
    PR[Pull Request para hom] --> Review[Code Review]
    Review --> Approval[Aprovação Manual]
    Approval --> GH[GitHub Actions]
    GH --> Deploy[Deploy para EKS HOM]
    Deploy --> QA[Testes QA]
    QA --> Approve[Aprovação para Prod]

Produção (PROD)
graph LR
    Merge[Merge para main] --> GH[GitHub Actions]
    GH --> Deploy[Deploy para EKS PROD]
    Deploy --> Monitor[Monitoramento]
    Monitor --> Rollback[Rollback Automático se falhar]

🛡️ Segurança

Controles Implementados
✅ Autenticação: OIDC com GitHub, IAM Roles for Service Accounts
✅ Autorização: RBAC granular, Policies baseadas em namespaces
✅ Rede: Security Groups, Network Policies, WAF no ALB
✅ Secrets: AWS Secrets Manager, encriptação em repouso/trânsito
✅ Compliance: CIS Benchmark, AWS Well-Architected Framework

Security Scanning
# Pipeline inclui automaticamente:
- SAST: Semgrep, Bandit
- SCA: Dependency scanning
- DAST: ZAP Proxy
- Container: Trivy para imagens
- IaC: Checkov para Terraform

💰 FinOps & Otimização de Custos

Estratégias Implementadas
- -Cluster Autoscaler: Escala nodes baseado em demanda
- Spot Instances: Até 70% de economia com nodes spot
- Right-sizing: Resource requests/limits otimizados
- Tagging: Tags consistentes para chargeback
- Budgets: Alertas de custo no AWS Budgets

Estimativa de Custos (DEV)
-Recurso	                        Custo Mensal
-EKS Control Plane	                $73.00
-EC2 Worker Nodes (3x t3.medium)	~$90.00
-ECR Storage	                    ~$5.00
-ALB	                            ~$20.00
--Total Estimado	                ~$188.00/mês

📈 Monitoramento e Alertas

Dashboards Disponíveis
- Cluster Overview: Saúde do cluster, uso de recursos
- Node Metrics: CPU, memória, disco por node
- Pod Metrics: Performance por pod/namespace
- ALB Metrics: Requisições, latência, erros
- Cost Dashboard: Gasto por namespace/time