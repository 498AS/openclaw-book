#!/bin/bash
# Post-action hook example (Cap. 7)
# Se ejecuta después de que el agente complete una acción

ACTION="$1"
RESULT="$2"

# Notificar acciones importantes
case "$ACTION" in
    "send_email")
        # Enviar notificación push
        curl -s "https://api.pushover.net/1/messages.json" \
            -d "token=YOUR_TOKEN" \
            -d "user=YOUR_USER" \
            -d "message=Email enviado: $RESULT"
        ;;
    "delete_file")
        # Log de borrados (auditoría)
        echo "[$(date)] DELETED: $RESULT" >> ~/.openclaw/logs/deletions.log
        ;;
    "execute_bash")
        # Log de comandos ejecutados
        echo "[$(date)] BASH: $RESULT" >> ~/.openclaw/logs/commands.log
        ;;
esac

exit 0
