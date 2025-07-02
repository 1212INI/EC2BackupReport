Reporte de Instancias EC2 y su Protección con AWS Backup
=========================================================

Este script (`ec2_backup_report.sh`) genera un reporte en formato CSV con información clave de todas las instancias EC2 en la cuenta, e indica si están protegidas mediante AWS Backup.

Requisitos
----------
- AWS CLI configurado con permisos para EC2 y AWS Backup
- jq instalado (para procesar JSON)

¿Qué hace?
----------
1. Obtiene todas las instancias EC2.
2. Obtiene la lista de recursos EC2 protegidos por AWS Backup.
3. Para cada instancia EC2, muestra:
   - Nombre (Tag Name)
   - ID de instancia
   - Tipo (familia)
   - IP privada y pública
   - Plataforma (Linux o Windows)
   - Arquitectura (x86_64, arm64, etc.)
   - Estado (running, stopped, etc.)
   - Si está protegida por AWS Backup

Uso
---
1. Dale permisos de ejecución:

   chmod +x ec2_backup_report.sh

2. Ejecuta:

   ./ec2_backup_report.sh

3. El resultado es un listado en formato CSV que se imprime por consola, listo para guardar como archivo si lo deseas:

   ./ec2_backup_report.sh > reporte_ec2_backup.csv

Notas
-----
- Las instancias sin respaldo activo aparecerán con "No" en la última columna.
- El script asume que las instancias tienen etiquetas estándar. Si no hay `Name`, se muestra "N/A".
