# Receta 3: Gestión Automática de Email

> Tu agente filtra, responde y archiva emails según tus reglas

## Configuración

### 1. Crear el skill

Añade a tu `skills/` un archivo `email-manager.md`:

```markdown
# Email Manager Skill

Gestiona mi bandeja de entrada siguiendo estas reglas:

## Filtrado automático
- **Newsletters**: Archivar en "Lecturas" sin marcar como leído
- **Facturas**: Extraer datos, archivar en "Facturas/2026"
- **Spam/Promociones**: Eliminar directamente
- **Urgentes**: Notificarme inmediatamente por WhatsApp

## Respuestas automáticas
- **Confirmaciones de reunión**: Aceptar y añadir al calendario
- **Solicitudes de disponibilidad**: Responder con mis slots libres esta semana
- **Emails de "solo informativo"**: Marcar como leído, archivar

## Resumen
Cada 2 horas, si hay emails importantes sin procesar, envíame un resumen.

## Excepciones
NUNCA responder automáticamente a:
- Clientes (dominio: @cliente.com)
- Emails con "urgente" o "confidencial"
- Threads con más de 3 participantes
```

### 2. Configurar el cron

```bash
# Procesar emails cada 30 minutos
*/30 * * * * openclaw run email-manager

# Resumen cada 2 horas en horario laboral
0 9,11,13,15,17 * * 1-5 openclaw run email-summary
```

### 3. Ejemplo de output

```
📧 RESUMEN EMAIL (14:00)

✅ PROCESADOS (últimas 2h):
• 3 newsletters → archivadas
• 1 factura Notion → extraída y archivada
• 2 confirmaciones reunión → aceptadas

⚠️ REQUIEREN ATENCIÓN:
• Email de María (Ford) - Pregunta sobre propuesta
• Thread con equipo 498AS - Decisión pendiente

🤖 RESPUESTAS ENVIADAS:
• A: pedro@proveedor.com
  Re: "¿Tienes disponibilidad?"
  → Enviado: "Tengo hueco el jueves 16:00 o viernes 10:00"

📊 Bandeja: 12 no leídos (3 importantes)
```

## Configuración IMAP/OAuth

Para que el agente acceda a tu email:

```yaml
# ~/.openclaw/integrations/email.yaml
provider: gmail
auth: oauth2
scopes:
  - gmail.readonly
  - gmail.modify
  - gmail.labels
rules_file: ~/.openclaw/email-rules.yaml
```

## Variaciones

- **Versión minimalista**: Solo filtrar y archivar, nunca responder
- **Versión agresiva**: Responder a todo excepto whitelist
- **Modo vacaciones**: Auto-responder con fecha de vuelta, archivar todo
