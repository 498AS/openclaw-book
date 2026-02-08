# Receta 5: Backup Automático de Archivos Importantes

> Tu agente mantiene copias de seguridad de lo que importa

## Configuración

### 1. Crear el skill

Añade a tu `skills/` un archivo `auto-backup.md`:

```markdown
# Auto Backup Skill

Gestiona backups automáticos de archivos y carpetas importantes.

## Carpetas a respaldar
- ~/Documents/proyectos/ → Diario
- ~/Documents/OBSIDIAN_WORKSPACE/ → Cada 6 horas
- ~/.claude/ → Diario
- ~/Pictures/Screenshots/ → Semanal

## Destinos de backup
1. **Local**: /Volumes/Backup/openclaw-backups/
2. **Remoto**: s3://mi-bucket/backups/ (opcional)
3. **Git**: Para archivos de configuración

## Estrategia de retención
- Últimos 7 días: mantener todos
- Última semana a mes: mantener 1 por semana
- Más de un mes: mantener 1 por mes
- Más de 6 meses: eliminar

## Verificación
Después de cada backup:
1. Verificar integridad (checksum)
2. Comprobar que el tamaño es razonable
3. Notificar si algo falla

## Notificaciones
- Éxito: Solo en resumen semanal
- Fallo: Inmediatamente por WhatsApp
```

### 2. Script de backup

Crea `scripts/backup.sh`:

```bash
#!/bin/bash
# Backup inteligente con rsync

BACKUP_BASE="/Volumes/Backup/openclaw-backups"
DATE=$(date +%Y-%m-%d_%H-%M)
LOG_FILE="$BACKUP_BASE/logs/backup-$DATE.log"

# Crear directorio de fecha
mkdir -p "$BACKUP_BASE/$DATE"
mkdir -p "$BACKUP_BASE/logs"

# Función de backup
backup_folder() {
    local src="$1"
    local name="$2"

    echo "Respaldando $name..." >> "$LOG_FILE"

    rsync -avz --delete \
        --exclude='.DS_Store' \
        --exclude='node_modules' \
        --exclude='.git' \
        "$src" "$BACKUP_BASE/$DATE/$name/" 2>> "$LOG_FILE"

    if [ $? -eq 0 ]; then
        echo "✅ $name completado" >> "$LOG_FILE"
    else
        echo "❌ $name falló" >> "$LOG_FILE"
        openclaw notify "🚨 Backup falló: $name"
    fi
}

# Ejecutar backups
backup_folder ~/Documents/proyectos "proyectos"
backup_folder ~/Documents/OBSIDIAN_WORKSPACE "obsidian"
backup_folder ~/.claude "claude-config"

# Calcular tamaño total
TOTAL_SIZE=$(du -sh "$BACKUP_BASE/$DATE" | cut -f1)
echo "📦 Backup completado: $TOTAL_SIZE" >> "$LOG_FILE"

# Limpiar backups antiguos (más de 30 días)
find "$BACKUP_BASE" -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \;
```

### 3. Configurar el cron

```bash
# Backup diario a las 2:00 AM
0 2 * * * /path/to/backup.sh

# Verificación de integridad semanal
0 3 * * 0 openclaw run verify-backups
```

### 4. Ejemplo de output

**Notificación de error (inmediata):**
```
🚨 BACKUP FALLIDO

📁 Carpeta: ~/Documents/proyectos
⏰ Hora: 02:15 AM
❌ Error: Disco de backup no montado

📋 Acción requerida:
1. Conectar disco "Backup"
2. Ejecutar: openclaw run backup --retry

💡 Último backup exitoso: hace 2 días
```

**Resumen semanal:**
```
📦 RESUMEN BACKUPS SEMANAL

✅ Backups exitosos: 7/7

📊 Estadísticas:
• Proyectos: 2.3 GB (sin cambios)
• Obsidian: 890 MB (+45 MB esta semana)
• Config Claude: 12 MB (+2 MB)

💾 Espacio usado: 45 GB de 500 GB
🗑️ Limpieza: 3 backups antiguos eliminados

📅 Próximo backup: Esta noche 02:00
```

## Variaciones

- **Versión cloud**: Subir a S3/B2/Google Drive en lugar de disco local
- **Versión incremental**: Solo respaldar archivos modificados
- **Versión con encriptación**: Cifrar backups con GPG antes de subir
