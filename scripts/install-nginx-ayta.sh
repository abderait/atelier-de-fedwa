#!/bin/bash

# Script d'installation de la configuration Nginx pour ayta.fr
# Usage: sudo ./scripts/install-nginx-ayta.sh

echo "🚀 Installation de la configuration Nginx pour ayta.fr..."

# Vérifier que le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Veuillez exécuter ce script avec sudo"
    exit 1
fi

# Variables
NGINX_CONF_D="/etc/nginx/conf.d"
CONFIG_FILE="ayta.fr.conf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📁 Répertoire du script: $SCRIPT_DIR"

# 1. Copier la configuration
echo "📄 Copie de la configuration Nginx..."
cp "$SCRIPT_DIR/nginx-ayta.conf" "$NGINX_CONF_D/$CONFIG_FILE"

# 2. Configuration déjà active (conf.d)
echo "🔗 Configuration activée dans conf.d..."

# 3. Tester la configuration
echo "🧪 Test de la configuration Nginx..."
nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Configuration Nginx valide"
    
    # 4. Recharger Nginx
    echo "🔄 Rechargement de Nginx..."
    systemctl reload nginx
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx rechargé avec succès"
    else
        echo "❌ Erreur lors du rechargement de Nginx"
        exit 1
    fi
else
    echo "❌ Configuration Nginx invalide"
    exit 1
fi

# 5. Vérifier le statut
echo "📊 Statut de Nginx:"
systemctl status nginx --no-pager -l

echo ""
echo "🎉 Installation terminée !"
echo ""
echo "📋 Prochaines étapes:"
echo "1. Configurez votre certificat SSL dans:"
echo "   - /etc/ssl/certs/ayta.fr.crt"
echo "   - /etc/ssl/private/ayta.fr.key"
echo ""
echo "2. Ou utilisez Let's Encrypt:"
echo "   sudo certbot --nginx -d ayta.fr -d www.ayta.fr"
echo "3. Vérifiez que votre site fonctionne:"
echo "   curl -I https://ayta.fr"
echo ""
echo "4. Consultez les logs si nécessaire:"
echo "   sudo tail -f /var/log/nginx/ayta.fr.access.log"
echo "   sudo tail -f /var/log/nginx/ayta.fr.error.log"

