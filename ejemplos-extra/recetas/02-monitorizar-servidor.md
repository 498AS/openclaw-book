# Receta 2: Monitorización de Servidor

> Tu agente vigila tu servidor y te avisa si algo falla

## Configuración

### 1. Script de monitorización

Crea `monitoring/check-server.sh`:

```bash
#!/bin/bash
# Comprueba estado del servidor cada 5 minutos

ENDPOINTS=(
    "https://tuapp.com/health"
    "https://api.tuapp.com/status"
    "https://admin.tuapp.com"
)

for url in "${ENDPOINTS[@]}"; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 10)

    if [ "$status" != "200" ]; then
        echo "ALERTA: $url devolvió $status"
        openclaw notify "🚨 Servidor caído: $url (status: $status)"
    fi
done
```

### 2. Configurar el cron

```bash
*/5 * * * * /path/to/check-server.sh
```

### 3. Skill de diagnóstico

Cuando el agente detecta un problema, puede ejecutar diagnósticos:

```markdown
# Server Diagnostic Skill

Cuando recibas una alerta de servidor caído:

1. Verifica el estado actual con curl
2. Revisa los logs recientes (últimos 100 líneas)
3. Comprueba uso de CPU y memoria
4. Intenta reiniciar el servicio si es seguro
5. Documenta el incidente
6. Notifícame con resumen y acciones tomadas
```

## Ejemplo de notificación

```
🚨 INCIDENTE SERVIDOR

⏰ Detectado: 03:47 AM
🔗 Endpoint: https://api.tuapp.com/status
❌ Status: 502 Bad Gateway

📋 Diagnóstico:
• Memoria: 94% (crítico)
• CPU: 12% (normal)
• Último error en logs: "Out of memory"

✅ Acción tomada:
• Reiniciado servicio node
• Liberada caché
• Servicio restaurado a las 03:49

📊 Tiempo de caída: 2 minutos
```

## Notas

- Ajusta el intervalo según criticidad (1 min para producción crítica)
- Añade más endpoints según necesites
- Considera integrar con PagerDuty o similar para escalado
