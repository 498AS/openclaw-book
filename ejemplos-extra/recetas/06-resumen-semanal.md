# Receta 6: Resumen Semanal de Actividad

> Tu agente te prepara un informe ejecutivo cada domingo

## Configuración

### 1. Crear el skill

Añade a tu `skills/` un archivo `weekly-summary.md`:

```markdown
# Weekly Summary Skill

Cada domingo a las 20:00, genera un resumen ejecutivo de la semana.

## Secciones del informe

### 1. Resumen ejecutivo
- 3 logros principales
- 1 obstáculo o problema
- Foco recomendado para la próxima semana

### 2. Productividad
- Tareas completadas vs planificadas
- Tiempo en reuniones
- Proyectos con más actividad

### 3. Comunicación
- Emails enviados/recibidos
- Reuniones realizadas
- Conversaciones destacadas

### 4. Código (si aplica)
- Commits realizados
- PRs mergeadas
- Issues cerrados

### 5. Finanzas (si configurado)
- Gastos de la semana
- Facturas emitidas
- Pagos pendientes

### 6. Próxima semana
- Reuniones programadas
- Deadlines importantes
- Sugerencias de priorización

## Formato
Breve, escaneable, con métricas claras.
Máximo 1 página si se imprimiera.
```

### 2. Configurar el cron

```bash
# Resumen semanal cada domingo a las 20:00
0 20 * * 0 openclaw run weekly-summary
```

### 3. Fuentes de datos

El agente recopila información de:

```yaml
# ~/.openclaw/weekly-sources.yaml
sources:
  calendar:
    provider: google
    metrics: [meetings_count, meeting_hours]

  email:
    provider: gmail
    metrics: [sent, received, response_time]

  tasks:
    provider: todoist  # o notion, things, etc.
    metrics: [completed, created, overdue]

  git:
    repos:
      - ~/Documents/proyectos/*
    metrics: [commits, prs, issues]

  finance:
    provider: expenses_folder  # o app específica
    path: ~/Documents/Finanzas/2026/
```

### 4. Ejemplo de output

```
📊 RESUMEN SEMANAL
Semana del 13 al 19 de enero 2026

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 RESUMEN EJECUTIVO

Logros:
✅ Cerrada propuesta CaixaBank (45K€)
✅ Lanzado MVP de GEOradar v2
✅ Contratado nuevo desarrollador

Obstáculo:
⚠️ Retraso en proyecto Ford (dependencia externa)

Foco próxima semana:
→ Preparar demo para Banco Sabadell

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📈 PRODUCTIVIDAD

Tareas: 23/28 completadas (82%)
Reuniones: 14 (8.5 horas)
Proyecto más activo: GEOradar

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📧 COMUNICACIÓN

Emails: 45 recibidos, 32 enviados
Tiempo respuesta medio: 2.3 horas
Thread más largo: Negociación Ford (12 msgs)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 CÓDIGO

Commits: 47
PRs mergeadas: 8
Issues cerrados: 12
Repos activos: georadar, sam-api

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💰 FINANZAS

Gastos semana: 234€
  - Software: 89€
  - Comidas trabajo: 145€
Facturas emitidas: 2 (12.500€)
Pendiente cobro: 3 facturas (28.000€)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📅 PRÓXIMA SEMANA

Lun: Daily equipo, Llamada Ford
Mar: Demo Banco Sabadell ⭐
Mié: Revisión sprint
Jue: Entrevista candidato UX
Vie: Cierre mes Q4

Deadlines:
• Propuesta LIDL (martes)
• Entrega fase 1 GEOradar (viernes)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Generado por OpenClaw | 19/01/2026 20:00
```

## Variaciones

- **Versión equipo**: Incluye métricas de todo el equipo, no solo personales
- **Versión cliente**: Resumen de actividad en proyecto específico para compartir
- **Versión mínima**: Solo logros + foco próxima semana (5 líneas)
