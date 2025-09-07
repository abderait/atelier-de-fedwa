#!/bin/bash

# Script de déploiement pour L'Atelier de Fedwa
# Déploie la version de production sur le serveur

echo "🚀 Deploying L'Atelier de Fedwa..."

# Configuration
SERVER="root@5.182.18.4"
REMOTE_DIR="/var/www/dev"
LOCAL_DIST="dist/"

# Vérifier que le dossier dist existe
if [ ! -d "$LOCAL_DIST" ]; then
    echo "❌ Dossier dist/ non trouvé. Exécutez d'abord ./scripts/build.sh"
    exit 1
fi

# Construire la version de production
echo "🏗️  Building production version..."
./scripts/build.sh

# Synchroniser les fichiers
echo "📤 Uploading files to server..."
rsync -avz --delete "$LOCAL_DIST" "$SERVER:$REMOTE_DIR/"

# Recharger Nginx
echo "🔄 Reloading Nginx..."
ssh "$SERVER" "sudo systemctl reload nginx"

echo "✅ Deployment completed successfully!"
echo "🌐 Site available at: http://dev.ayta.fr"