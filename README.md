# Desenvolvimento-AWS (EKS Platform Demo) 

Projeto de demonstração (nível sênior) para provisionar e operar uma plataforma Kubernetes na AWS com foco em:
- Terraform (IaC) com módulos e governança
- EKS Kubernetes v1.35
- Gateway API (sem Ingress NGINX)
- CI/CD com GitHub Actions + OIDC (sem secrets estáticos)
- Observabilidade (Kubernetes Dashboard + Prometheus/Grafana)
- Segurança (shift-left: SAST/SCA/DAST + scan de imagem)
- FinOps (tagging + budgets + modo demo)

## Ambientes
- DEV: demo econômica (recursos mínimos para apresentação)
- HOM: homologação (gates/approvals)
- PROD: blueprint completo (arquitetura alvo)

## Estrutura
- `terraform/`: infraestrutura AWS (VPC, EKS, ECR, etc.)
- `k8s/`: add-ons e manifests (Dashboard, Gateway API, namespaces)
- `.github/workflows/`: pipelines CI/CD

## Demo rápida (DEV)
> (vamos preencher na Parte 3/4 quando EKS estiver de pé)
1. `terraform apply` do DEV
2. `aws eks update-kubeconfig ...`
3. `kubectl get pods -A`
4. Abrir Kubernetes Dashboard (localhost)
5. Abrir Grafana (dashboards de cluster/pods)
