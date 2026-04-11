\# TCC - Automação HPA com Jenkins + Kubernetes



\## Estrutura

\- k8s-manifests/ → deployment.yaml, service.yaml, hpa.yaml

\- jenkins-files/ → Jenkinsfile, scripts

\- test-files/ → loadtest.js, comparativos

\- monitoring/ → Prometheus, Grafana configs, dados coletados



\## Stack de Monitoramento

\- kubectl top: Métricas rápidas 

\- Prometheus + Grafana: Análise histórica 

\- k6: Testes carga 



\## Quick Start

1\. minikube start --driver=docker --cpus=4 --memory=8g

2\. docker compose up -d

3\. kubectl apply -f k8s-manifests/

