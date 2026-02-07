# Receta 1: Resumen Matutino Automático

> Tu agente te envía cada mañana un resumen de tu día

## Configuración

### 1. Crear el skill

Añade a tu `skills/` un archivo `morning-briefing.md`:

```markdown
# Morning Briefing Skill

Cada mañana a las 7:00, genera y envía un resumen del día que incluya:

1. **Calendario**: Reuniones y eventos del día
2. **Tareas pendientes**: Las 3 más importantes
3. **Emails urgentes**: Cualquier email marcado como importante sin responder
4. **Clima**: Previsión para hoy
5. **Recordatorios**: Cualquier cosa que me hayas prometido recordar

Formato: Breve, escaneable, con emojis para categorías.
Envía por: WhatsApp
```

### 2. Configurar el cron

En tu sistema, añade:

```bash
0 7 * * * openclaw run morning-briefing
```

### 3. Ejemplo de output

```
🌅 Buenos días, Carlos

📅 HOY:
• 09:00 - Daily con el equipo
• 11:30 - Llamada cliente Veolia
• 16:00 - Revisión proyecto 498AS

✅ PRIORIDADES:
1. Revisar propuesta CaixaBank (deadline mañana)
2. Responder email de Adrián
3. Cerrar PR de documentación

📧 PENDIENTE:
• Email de Ford (hace 2 días, marcado importante)

🌤️ Barcelona: 18°C, parcialmente nublado

Buen día.
```

## Variaciones

- **Versión ejecutiva**: Solo las 3 cosas más importantes
- **Versión detallada**: Incluye contexto de cada reunión
- **Versión fin de semana**: Solo recordatorios personales
