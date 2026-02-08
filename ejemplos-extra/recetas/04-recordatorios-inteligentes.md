# Receta 4: Recordatorios Inteligentes

> Tu agente recuerda cosas por ti y te avisa en el momento adecuado

## Configuración

### 1. Crear el skill

Añade a tu `skills/` un archivo `smart-reminders.md`:

```markdown
# Smart Reminders Skill

Gestiona recordatorios de forma inteligente basándote en contexto.

## Tipos de recordatorios

### Temporales
- "Recuérdame X en 2 horas" → Notificar en 2h
- "Recuérdame X mañana por la mañana" → 9:00 del día siguiente
- "Recuérdame X el lunes" → Lunes 9:00

### Contextuales
- "Recuérdame X cuando hable con María" → Antes de reunión con María
- "Recuérdame X cuando esté en la oficina" → Al detectar ubicación
- "Recuérdame X cuando abra el proyecto Y" → Al detectar actividad

### Recurrentes
- "Recuérdame revisar X cada viernes" → Viernes 10:00
- "Recuérdame Y el día 1 de cada mes" → Día 1, 9:00

## Formato de notificación
Incluye siempre:
1. El recordatorio original
2. Contexto de por qué lo pedí (si lo mencioné)
3. Acciones sugeridas si aplica

## Persistencia
Guarda los recordatorios en ~/.openclaw/reminders.json
Revísalos cada 5 minutos para disparar los que toquen
```

### 2. Configurar el cron

```bash
# Comprobar recordatorios cada 5 minutos
*/5 * * * * openclaw run check-reminders
```

### 3. Almacenamiento de recordatorios

```json
// ~/.openclaw/reminders.json
{
  "reminders": [
    {
      "id": "rem_001",
      "text": "Llamar a Carlos para cerrar propuesta",
      "created": "2026-01-15T10:30:00Z",
      "trigger": {
        "type": "datetime",
        "value": "2026-01-17T09:00:00Z"
      },
      "context": "Quedamos en hablar después del puente",
      "status": "pending"
    },
    {
      "id": "rem_002",
      "text": "Preguntar por el presupuesto del proyecto",
      "created": "2026-01-15T14:00:00Z",
      "trigger": {
        "type": "person",
        "value": "María García"
      },
      "context": "En la próxima reunión con ella",
      "status": "pending"
    }
  ]
}
```

### 4. Ejemplo de output

**Recordatorio temporal:**
```
⏰ RECORDATORIO

📌 Llamar a Carlos para cerrar propuesta

📅 Programado: Hoy 9:00
💭 Contexto: "Quedamos en hablar después del puente"

📞 Acciones sugeridas:
• Teléfono Carlos: +34 612 345 678
• Último email: hace 3 días (propuesta v2)
• Documento relacionado: Propuesta_Ford_v2.pdf
```

**Recordatorio contextual:**
```
💡 RECORDATORIO ANTES DE REUNIÓN

📌 Preguntar por el presupuesto del proyecto

👤 Contexto: Reunión con María García en 15 minutos
📍 Sala: Teams - Enlace copiado

💭 Por qué: "En la próxima reunión con ella"
```

## Variaciones

- **Versión simple**: Solo recordatorios temporales, sin contexto
- **Versión con follow-up**: Si no confirmo que hice la tarea, re-recordar en 1h
- **Versión con dependencias**: "Recuérdame Y después de hacer X"
