#!/bin/bash
# Pre-message hook example (Cap. 7)
# Se ejecuta antes de que el agente procese un mensaje

MESSAGE="$1"
CHANNEL="$2"

# Log de todos los mensajes entrantes
echo "[$(date)] [$CHANNEL] $MESSAGE" >> ~/.openclaw/logs/messages.log

# Filtro de spam básico
if echo "$MESSAGE" | grep -qi "crypto\|bitcoin\|nft"; then
    echo "SPAM_DETECTED"
    exit 1
fi

# Continuar procesamiento normal
exit 0
