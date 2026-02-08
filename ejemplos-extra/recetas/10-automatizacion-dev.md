# Receta 10: Automatizacion de Tareas de Desarrollo

> Tu agente gestiona PRs, deploys, y tareas repetitivas de desarrollo

## Configuracion

### 1. Crear el skill

Añade a tu `skills/` un archivo `dev-automation.md`:

```markdown
# Dev Automation Skill

Automatiza tareas repetitivas del flujo de desarrollo.

## Pull Requests

### Al crear PR
1. Verificar que pasa linting y tests
2. Añadir labels según archivos modificados
3. Asignar reviewers según CODEOWNERS
4. Generar descripción con resumen de cambios
5. Linkear issues relacionados

### Al recibir review
- Si approved: Notificarme para merge
- Si changes requested: Crear tareas con los cambios pedidos
- Si comentario: Notificar solo si es pregunta

### Al mergear
1. Eliminar rama
2. Actualizar changelog
3. Notificar en Slack del equipo

## Deploys

### Deploy a staging
Automático en cada merge a main:
1. Ejecutar pipeline CI/CD
2. Esperar a que pase
3. Verificar health check
4. Notificar: "Staging actualizado con X, Y, Z"

### Deploy a producción
Solo manual, pero asistido:
1. Generar lista de cambios desde último deploy
2. Verificar que staging está estable (24h sin errores)
3. Confirmar conmigo antes de ejecutar
4. Post-deploy: verificar métricas 15 min

## Mantenimiento

### Dependencias
- Revisar Dependabot/Renovate PRs semanalmente
- Aprobar automáticamente patches de seguridad
- Agrupar minor updates en un PR semanal

### Issues
- Cerrar stale issues (sin actividad 30 días)
- Etiquetar automáticamente según contenido
- Asignar a milestone según labels
```

### 2. Configuración de repositorios

```yaml
# ~/.openclaw/dev-config.yaml
repositories:
  - name: georadar-api
    path: ~/Documents/proyectos/georadar-api
    github: zoopa-agency/georadar-api
    auto_deploy_staging: true
    require_approval_prod: true

  - name: sam-frontend
    path: ~/Documents/proyectos/sam-frontend
    github: zoopa-agency/sam-frontend
    auto_deploy_staging: true
    require_approval_prod: true

notifications:
  slack:
    webhook: ${SLACK_WEBHOOK}
    channel: "#deploys"
  personal:
    method: whatsapp
    events: [pr_approved, deploy_failed, critical_alert]

ci_cd:
  provider: github_actions
  staging_branch: main
  prod_branch: production
```

### 3. Configurar el cron

```bash
# Comprobar PRs pendientes cada 30 min
*/30 * * * * openclaw run check-pending-prs

# Resumen diario de estado repos
0 9 * * 1-5 openclaw run dev-daily-status

# Mantenimiento semanal (dependencias, issues stale)
0 10 * * 1 openclaw run dev-weekly-maintenance
```

### 4. Ejemplo de output

**Notificación de PR aprobada:**
```
✅ PR APROBADA - Lista para merge

📦 Repo: georadar-api
🔀 PR: #234 - Add batch processing endpoint
👤 Autor: carlos
✅ Approved by: maria, juan

📊 Estado:
• Tests: ✅ Passed (45/45)
• Coverage: 87% (+2%)
• Build: ✅ Success
• Security: ✅ No vulnerabilities

📝 Cambios:
• 3 archivos modificados (+156, -23)
• Nuevo endpoint: POST /api/v1/batch
• Tests añadidos: 8

🚀 ¿Merge y deploy a staging?
```

**Resumen diario de desarrollo:**
```
🛠️ DEV STATUS - 15 enero

━━━━ PRs ABIERTAS ━━━━
📦 georadar-api
  • #234 Batch processing ✅ Ready to merge
  • #231 Fix memory leak 🔄 In review

📦 sam-frontend
  • #89 New dashboard 💬 Changes requested
  • #88 Dark mode 🔄 In review (2 días)

━━━━ DEPLOYS ━━━━
Staging: actualizado hace 2h (PR #233)
Producción: v2.3.1 (hace 5 días)

Pendiente producción:
• 4 PRs mergeadas desde último deploy
• Cambios: batch endpoint, fixes, UI updates

━━━━ CI/CD ━━━━
• Builds últimas 24h: 12 (10 ✅, 2 ❌)
• Tiempo medio build: 4m 23s
• Failures: #231 (test flaky), #88 (lint)

━━━━ DEPENDENCIAS ━━━━
• 3 security updates pendientes
• 8 minor updates agrupados en PR #235

━━━━ ACCIONES SUGERIDAS ━━━━
1. Mergear #234 (aprobada hace 1 día)
2. Revisar #88 (en review 2 días)
3. Aprobar security updates
```

**Post-deploy a producción:**
```
🚀 DEPLOY PRODUCCIÓN COMPLETADO

📦 georadar-api v2.4.0
⏰ Completado: 15 enero 14:32

━━━━ CAMBIOS INCLUIDOS ━━━━
• #234 Add batch processing endpoint
• #233 Fix rate limiting bug
• #229 Performance improvements
• #227 Update dependencies

━━━━ VERIFICACIÓN ━━━━
✅ Health check: OK
✅ Response time: 145ms (normal)
✅ Error rate: 0.01% (normal)
✅ CPU/Memory: normal

━━━━ ROLLBACK ━━━━
Si hay problemas:
$ ./scripts/rollback.sh v2.3.1

━━━━ MONITORIZACIÓN ━━━━
Vigilando métricas próximos 30 min.
Te notifico si hay anomalías.

📊 Dashboard: https://grafana.example.com/d/prod
```

**Mantenimiento semanal:**
```
🔧 MANTENIMIENTO SEMANAL - 20 enero

━━━━ DEPENDENCIAS ━━━━
✅ Security patches aplicados: 3
  • lodash: 4.17.20 → 4.17.21 (CVE-2021-xxxx)
  • axios: 0.21.1 → 0.21.4 (security)
  • node: 18.17.0 → 18.17.1 (security)

📦 PR creada con minor updates: #240
  • 8 dependencias agrupadas
  • Tests passing
  → Requiere tu aprobación

━━━━ ISSUES ━━━━
🗑️ Cerradas por inactividad: 5
  • #180 Feature request (90 días sin actividad)
  • #167 Question (120 días)
  • ...

🏷️ Re-etiquetadas: 3
  • #220 bug → needs-reproduction
  • #218 feature → enhancement

━━━━ CÓDIGO ━━━━
📊 Cobertura media repos: 84%
  • georadar-api: 87% (+2%)
  • sam-frontend: 81% (=)

⚠️ Archivos sin tests detectados:
  • src/utils/newHelper.ts

━━━━ PRÓXIMAS ACCIONES ━━━━
1. Revisar PR #240 (dep updates)
2. Añadir tests a newHelper.ts
3. Planificar deploy producción (4 PRs pendientes)
```

## Variaciones

- **Versión monorepo**: Gestionar múltiples packages en un solo repo
- **Versión open source**: Incluir gestión de contributors y releases públicos
- **Versión GitOps**: Integrar con ArgoCD/Flux para deploys declarativos
- **Versión con feature flags**: Gestionar activación gradual de features
