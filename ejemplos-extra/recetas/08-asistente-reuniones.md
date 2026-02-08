# Receta 8: Asistente de Reuniones

> Tu agente toma notas, hace seguimiento y gestiona acciones de tus reuniones

## Configuracion

### 1. Crear el skill

Añade a tu `skills/` un archivo `meeting-assistant.md`:

```markdown
# Meeting Assistant Skill

Asiste antes, durante y después de cada reunión.

## Antes de la reunión (15 min antes)
1. Enviar briefing con:
   - Objetivo de la reunión
   - Participantes y su contexto
   - Últimas interacciones con ellos
   - Documentos relacionados
   - Acciones pendientes de reuniones anteriores

## Durante la reunión
Si me envías notas de voz o texto:
1. Transcribir y estructurar
2. Identificar decisiones tomadas
3. Extraer action items con responsable y fecha
4. Detectar temas para seguimiento

## Después de la reunión
1. Generar resumen ejecutivo
2. Crear tareas en el gestor de tareas
3. Enviar follow-up a participantes (si se pide)
4. Programar recordatorios de acciones
5. Actualizar CRM con notas del cliente (si aplica)

## Formato de notas
Estructurar siempre en:
- Decisiones
- Action items
- Puntos abiertos
- Próximos pasos
```

### 2. Configurar integración con calendario

```yaml
# ~/.openclaw/meeting-config.yaml
calendar:
  provider: google
  briefing_minutes_before: 15

transcription:
  enabled: true
  provider: whisper  # o assembly, deepgram

task_manager:
  provider: todoist  # o notion, things, asana
  project: "Meeting Actions"

crm:
  provider: notion  # o hubspot, salesforce
  database: "Clientes"
```

### 3. Configurar el cron

```bash
# Comprobar próximas reuniones cada 5 minutos
*/5 * * * * openclaw run check-upcoming-meetings

# Recordatorio de acciones pendientes cada mañana
0 9 * * 1-5 openclaw run meeting-actions-reminder
```

### 4. Ejemplo de output

**Briefing antes de reunión:**
```
📋 BRIEFING: Reunión con Ford

⏰ En 15 minutos (11:30 - 12:30)
📍 Teams - Enlace copiado al portapapeles
👥 Participantes:
   • María García (Marketing Director)
   • Juan López (Brand Manager)
   • Tú

🎯 Objetivo: Revisión propuesta fase 2 GEOradar

📂 Contexto:
• Última reunión: 10/01 (demo inicial, fueron positivos)
• Email pendiente: María preguntó por timeline
• Propuesta enviada: 12/01 (45K€, 3 meses)

📌 Acciones pendientes de reunión anterior:
• ⏳ Enviar caso de estudio Danone (tú - vence hoy)
• ✅ Revisar contrato legal (ellos - completado)

💡 Sugerencia: Llevar preparado el timeline detallado
   que María solicitó por email.
```

**Resumen post-reunión:**
```
📝 RESUMEN: Reunión Ford
11:30 - 12:45 | 15 enero 2026

━━━━ DECISIONES ━━━━
✓ Aprueban fase 2 con presupuesto de 45K€
✓ Inicio proyecto: 1 febrero
✓ Reuniones de seguimiento: quincenal

━━━━ ACTION ITEMS ━━━━
📌 Carlos:
  • Enviar contrato actualizado (18/01)
  • Preparar kickoff deck (25/01)
  • Configurar accesos plataforma (31/01)

📌 María (Ford):
  • Confirmar equipo interno (20/01)
  • Enviar assets de marca (22/01)

📌 Juan (Ford):
  • Aprobar contrato con legal (24/01)

━━━━ PUNTOS ABIERTOS ━━━━
• Definir si incluir mercado Portugal (decidir en kickoff)
• Posible ampliación a otros mercados Q2

━━━━ PRÓXIMOS PASOS ━━━━
📅 Kickoff: 1 febrero 10:00 (por agendar)
📧 Follow-up enviado a participantes

━━━━━━━━━━━━━━━━━━━━━━━━

✅ 3 tareas creadas en Todoist
📇 CRM actualizado (Ford → Cliente activo)
```

**Recordatorio de acciones:**
```
⏰ ACCIONES PENDIENTES DE REUNIONES

Vencen hoy:
🔴 Enviar contrato Ford (de reunión 15/01)

Próximos 3 días:
🟡 Preparar kickoff deck Ford (25/01)
🟡 Revisar propuesta LIDL (26/01)

Vencidas:
🔴 Enviar caso Danone a Ford (venció 15/01)
   → ¿La completo o la reprogramo?
```

## Variaciones

- **Versión grabación**: Integrar con Otter/Fireflies para transcripción automática
- **Versión 1:1**: Formato específico para reuniones one-on-one con equipo
- **Versión cliente**: Generar acta formal para enviar al cliente
- **Versión standup**: Formato rápido para dailies (solo blockers y updates)
