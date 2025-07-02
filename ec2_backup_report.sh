#!/bin/bash

# Reporte de Instancias EC2 y su Protección con AWS Backup

echo "Obteniendo instancias EC2..."
INSTANCES_JSON=$(aws ec2 describe-instances --output json)

echo "Obteniendo instancias EC2 con respaldo de AWS Backup..."
BACKUP_IDS=($(aws backup list-protected-resources \
  --output json | jq -r '.Results[] | select(.ResourceType=="EC2") | .ResourceArn' | awk -F'/' '{print $NF}'))

echo "Nombre,Instancia ID,Familia,IP Privada,IP Pública,OS,Arquitectura,Estado,Tiene Respaldo"

echo "$INSTANCES_JSON" | jq -c '.Reservations[].Instances[]' | while read -r instance; do
  NAME=$(echo "$instance" | jq -r '.Tags[]? | select(.Key=="Name") | .Value // "N/A"')
  INSTANCE_ID=$(echo "$instance" | jq -r '.InstanceId')
  INSTANCE_TYPE=$(echo "$instance" | jq -r '.InstanceType')
  PRIVATE_IP=$(echo "$instance" | jq -r '.PrivateIpAddress // "N/A"')
  PUBLIC_IP=$(echo "$instance" | jq -r '.PublicIpAddress // "N/A"')
  PLATFORM=$(echo "$instance" | jq -r '.Platform // "Linux/UNIX"')
  ARCHITECTURE=$(echo "$instance" | jq -r '.Architecture')
  STATE=$(echo "$instance" | jq -r '.State.Name')

  if [[ " ${BACKUP_IDS[@]} " =~ " $INSTANCE_ID " ]]; then
    BACKUP="Sí"
  else
    BACKUP="No"
  fi

  echo "$NAME,$INSTANCE_ID,$INSTANCE_TYPE,$PRIVATE_IP,$PUBLIC_IP,$PLATFORM,$ARCHITECTURE,$STATE,$BACKUP"
done
