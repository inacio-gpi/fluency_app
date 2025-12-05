#!/bin/bash

# Script para executar testes com cobertura de código
echo "Flutter Run Coverage (by Guilherme Pereira - github.com/inacio-gpi)"
echo "🧪 Rodando testes..."
flutter test --coverage

echo "📊 Gerando relatório de cobertura HTML..."
# Instalar lcov se necessário: brew install lcov (macOS) ou apt-get install lcov (Linux)

if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    echo "✅ Relatório de cobertura gerado em coverage/html/index.html"
    
    # Abrir automaticamente no navegador (opcional)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open coverage/html/index.html
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open coverage/html/index.html
    fi
else
    echo "⚠️  lcov não encontrado. Instale com 'brew install lcov' (macOS) ou 'apt-get install lcov' (Linux)"
    echo "   Arquivo de cobertura bruto disponível em coverage/lcov.info"
fi

echo "✨ Concluído!"

