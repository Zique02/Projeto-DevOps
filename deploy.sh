#!/bin/bash

set -e

IMAGE_NAME="projeto_devops_app"
CONTAINER_NAME="app_container"

echo "1. CONSTRUÇÃO E DEPLOY (Fase de Entrega)"
echo "Construindo a imagem Docker..."
docker build -t $IMAGE_NAME .

echo "Limpando container antigo..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "Iniciando aplicação"
docker run -d -p 3000:3000 --name $CONTAINER_NAME $IMAGE_NAME

echo "Aguardando aplicação iniciar..."
sleep 5

echo "2. SEGURANÇA (Fase de Verificação)"
echo "Executando análise de vulnerabilidades com OWASP ZAP..."


docker run --rm \
  --network host \
  -v "$(pwd -W):/zap/wrk:rw" \
  zaproxy/zap-stable zap-baseline.py \
  -t http://localhost:3000 \
  -r report_seguranca.html \
  -I

echo "PROCESSO FINALIZADO"
echo "Relatório de segurança salvo em report_seguranca.html"
