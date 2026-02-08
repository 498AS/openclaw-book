# Receta 9: Monitorizacion de Menciones en Redes

> Tu agente rastrea menciones de tu marca, competencia o temas de interes

## Configuracion

### 1. Crear el skill

Añade a tu `skills/` un archivo `social-monitor.md`:

```markdown
# Social Monitor Skill

Monitoriza menciones en redes sociales y web.

## Términos a monitorizar

### Mi marca
- "zoopa"
- "@zoopa_es"
- "georadar.app"
- "Carlos Ortet"

### Competencia
- "competidor1"
- "competidor2"

### Industria
- "generative engine optimization"
- "AI brand visibility"
- "LLM SEO"

## Fuentes
- Twitter/X (vía API o scraping)
- LinkedIn (menciones y posts)
- Reddit (subreddits relevantes)
- Hacker News
- Google Alerts
- Prensa digital

## Clasificación
Cada mención clasificar como:
- 🟢 Positiva
- 🟡 Neutral
- 🔴 Negativa
- ⭐ Oportunidad (alguien pregunta algo que resolvemos)

## Alertas
- Inmediata: Menciones negativas o crisis potencial
- Diaria: Resumen de menciones
- Semanal: Análisis de tendencias

## Acciones sugeridas
Para cada mención relevante, sugerir:
- Responder (con draft de respuesta)
- Ignorar
- Escalar a equipo
```

### 2. Configurar fuentes

```yaml
# ~/.openclaw/social-monitor.yaml
monitors:
  twitter:
    enabled: true
    terms: ["zoopa", "@zoopa_es", "georadar"]
    exclude: ["zoopa animal", "zoopa zoo"]  # falsos positivos

  linkedin:
    enabled: true
    company_page: "zoopa-agency"
    personal_profile: "carlosortet"

  reddit:
    enabled: true
    subreddits: ["artificial", "SEO", "marketing"]
    terms: ["generative engine", "AI visibility"]

  hackernews:
    enabled: true
    terms: ["LLM SEO", "AI search optimization"]

  google_alerts:
    enabled: true
    # Configurar alertas en Google y parsear emails

notifications:
  immediate:
    - sentiment: negative
    - keyword: "crisis"
    - mention_count_spike: 5  # 5x más que media

  digest:
    frequency: daily
    time: "09:00"
```

### 3. Configurar el cron

```bash
# Comprobar menciones cada hora
0 * * * * openclaw run check-social-mentions

# Resumen diario
0 9 * * * openclaw run social-daily-digest

# Análisis semanal
0 10 * * 1 openclaw run social-weekly-analysis
```

### 4. Ejemplo de output

**Alerta inmediata (mención negativa):**
```
🚨 ALERTA: Mención negativa detectada

📍 Fuente: Twitter
👤 Usuario: @usuario_enfadado (5.2K seguidores)
⏰ Hace: 12 minutos

💬 Mensaje:
"Probé @zoopa_es y la verdad que decepcionado.
El soporte tardó 3 días en responder y el problema
sigue sin resolverse. No lo recomiendo."

📊 Engagement actual:
• 3 retweets, 12 likes, 2 respuestas

🎯 Acciones sugeridas:
1. Responder públicamente (draft preparado)
2. Enviar DM privado
3. Escalar a equipo de soporte

📝 Draft de respuesta:
"Hola @usuario_enfadado, lamentamos mucho tu
experiencia. Nos tomamos esto muy en serio.
¿Podrías enviarnos un DM con los detalles?
Queremos resolverlo hoy mismo."

¿Qué acción tomo?
```

**Resumen diario:**
```
📊 MENCIONES SOCIALES - 15 enero

━━━━ RESUMEN ━━━━
Total menciones: 23
🟢 Positivas: 15 (65%)
🟡 Neutrales: 6 (26%)
🔴 Negativas: 2 (9%)

━━━━ DESTACADAS ━━━━

⭐ OPORTUNIDAD
Reddit r/SEO - Usuario pregunta:
"¿Alguien conoce herramientas para medir
visibilidad en ChatGPT/Perplexity?"
→ 45 upvotes, 12 comentarios
💡 Sugerencia: Responder mencionando GEOradar

🟢 POSITIVA
LinkedIn - Post de @influencer_marketing:
"Acabo de descubrir GEOradar y es exactamente
lo que necesitábamos para medir AI visibility"
→ 234 reacciones
💡 Sugerencia: Agradecer y compartir

🔴 NEGATIVA
Twitter - Queja de soporte (ya gestionada)

━━━━ COMPETENCIA ━━━━
• Competidor1: 8 menciones (neutral)
• Competidor2: 3 menciones (lanzaron feature nuevo)

━━━━ TENDENCIAS ━━━━
📈 "generative engine optimization" +40% esta semana
📈 "AI SEO" trending en LinkedIn
```

**Análisis semanal:**
```
📈 ANÁLISIS SEMANAL REDES
Semana 13-19 enero 2026

━━━━ MÉTRICAS ━━━━
Menciones totales: 156 (+23% vs semana anterior)
Sentimiento medio: 72% positivo
Alcance estimado: 45K impresiones

━━━━ TOP MENCIONES ━━━━
1. Post LinkedIn sobre GEOradar (2.3K views)
2. Thread Twitter sobre AI visibility (890 likes)
3. Mención en newsletter Marketing AI

━━━━ OPORTUNIDADES PERDIDAS ━━━━
• 3 preguntas en Reddit sin responder
• 1 mención de periodista tech sin seguimiento

━━━━ COMPETENCIA ━━━━
                Menciones  Sentimiento
Zoopa              156      72% 🟢
Competidor1         89      68% 🟢
Competidor2         45      71% 🟢

━━━━ RECOMENDACIONES ━━━━
1. Publicar más en Reddit (buen engagement)
2. Responder más rápido a oportunidades
3. El tema "AI visibility" está trending - crear contenido
```

## Variaciones

- **Versión personal branding**: Solo monitorizar tu nombre y respuestas
- **Versión PR/Crisis**: Enfocada en detección temprana de crisis
- **Versión competitiva**: Análisis profundo de competencia
- **Versión influencers**: Detectar menciones de cuentas con alto alcance
