# Receta 7: Control de Gastos

> Tu agente parsea recibos, categoriza gastos y te ayuda con el presupuesto

## Configuración

### 1. Crear el skill

Añade a tu `skills/` un archivo `expense-tracker.md`:

```markdown
# Expense Tracker Skill

Gestiona el control de gastos de forma automática.

## Entrada de gastos

### Por foto de recibo
Cuando reciba una foto de ticket/factura:
1. Extraer: fecha, comercio, importe, concepto
2. Categorizar automáticamente
3. Guardar en la base de datos
4. Confirmar con resumen breve

### Por mensaje de texto
"Gasté 45€ en cena de trabajo con cliente"
→ Parsear y registrar

### Por notificación bancaria
Integrar con alertas del banco para registro automático

## Categorías
- 🍽️ Comidas y restaurantes
- 🚗 Transporte
- 💻 Software y suscripciones
- 📱 Tecnología
- 🏠 Hogar y servicios
- 🎯 Marketing y publicidad
- 📚 Formación
- 🎁 Regalos y personal
- 💼 Material oficina
- ❓ Sin categorizar

## Alertas
- Aviso cuando gasto mensual supere presupuesto
- Resumen semanal de gastos
- Alerta de suscripciones próximas a renovar

## Almacenamiento
Guardar en: ~/.openclaw/expenses/2026.json
Adjuntos en: ~/.openclaw/expenses/receipts/
```

### 2. Estructura de datos

```json
// ~/.openclaw/expenses/2026.json
{
  "expenses": [
    {
      "id": "exp_001",
      "date": "2026-01-15",
      "amount": 45.00,
      "currency": "EUR",
      "merchant": "Restaurante Can Culleretes",
      "category": "comidas",
      "subcategory": "cena_trabajo",
      "description": "Cena con cliente Ford",
      "receipt": "receipts/2026-01-15_canculleretes.jpg",
      "payment_method": "tarjeta_empresa",
      "deductible": true,
      "tags": ["cliente", "ford"]
    }
  ],
  "budgets": {
    "comidas": { "monthly": 500, "current": 345 },
    "software": { "monthly": 200, "current": 89 },
    "transporte": { "monthly": 150, "current": 67 }
  },
  "subscriptions": [
    {
      "name": "Notion",
      "amount": 10,
      "frequency": "monthly",
      "next_charge": "2026-02-01",
      "category": "software"
    }
  ]
}
```

### 3. Configurar el cron

```bash
# Resumen diario de gastos (si hubo alguno)
0 21 * * * openclaw run daily-expenses

# Alerta de suscripciones próximas (3 días antes)
0 9 * * * openclaw run subscription-alerts

# Resumen mensual el día 1
0 10 1 * * openclaw run monthly-expenses
```

### 4. Ejemplo de output

**Al enviar foto de recibo:**
```
📝 GASTO REGISTRADO

🏪 Amazon
📅 15/01/2026
💰 89,99€

📦 Detectado: Teclado mecánico Keychron
📁 Categoría: Tecnología → Material oficina
💳 Método: Tarjeta empresa
✅ Deducible: Sí

📊 Este mes en Tecnología:
   189€ de 300€ presupuestados (63%)

¿Es correcto? Responde para corregir.
```

**Resumen semanal:**
```
💰 GASTOS SEMANA 13-19 ENE

Total: 456,78€

Por categoría:
🍽️ Comidas: 187€ (4 gastos)
💻 Software: 89€ (2 suscripciones)
🚗 Transporte: 67€ (3 gastos)
📱 Tecnología: 89€ (1 compra)
❓ Sin categorizar: 24€ (1 gasto)

⚠️ Alertas:
• Comidas al 78% del presupuesto mensual
• Gasto sin categorizar pendiente

📅 Próximas renovaciones:
• Notion (10€) - 1 febrero
• Figma (15€) - 3 febrero
```

**Alerta de presupuesto:**
```
⚠️ ALERTA PRESUPUESTO

📁 Categoría: Comidas
💰 Gastado: 487€ de 500€ (97%)
📅 Quedan 12 días de mes

📋 Últimos gastos:
• Ayer: Cena equipo 89€
• 15/01: Comida cliente 45€
• 14/01: Café reunión 12€

💡 Sugerencia: Quedan 13€ para el resto del mes.
   Considera limitar comidas fuera.
```

## Variaciones

- **Versión empresa**: Separar gastos personales vs empresa
- **Versión con OCR avanzado**: Usar Vision API para tickets difíciles
- **Versión con exportación**: Generar CSV para contabilidad mensual
- **Versión compartida**: Gastos de pareja/familia con presupuestos conjuntos
