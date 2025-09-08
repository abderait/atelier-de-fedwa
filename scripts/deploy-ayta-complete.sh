#!/bin/bash

# Script de déploiement complet pour ayta.fr
# Usage: sudo ./scripts/deploy-ayta-complete.sh

echo "🚀 Déploiement complet pour ayta.fr..."

# Vérifier que le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Veuillez exécuter ce script avec sudo"
    exit 1
fi

# Variables
NGINX_CONF_D="/etc/nginx/conf.d"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📁 Répertoire du script: $SCRIPT_DIR"

# 1. Afficher le menu
echo ""
echo "🎯 Choisissez une option:"
echo "1. Installer la configuration de base (HTTP uniquement)"
echo "2. Installer avec Let's Encrypt (HTTPS + wildcard)"
echo "3. Nettoyer et réinstaller"
echo "4. Vérifier la configuration actuelle"
echo ""
read -p "Votre choix (1-4): " choice

case $choice in
    1)
        echo "📄 Installation de la configuration de base..."
        "$SCRIPT_DIR/install-ayta-production.sh"
        ;;
    2)
        echo "🔐 Installation avec Let's Encrypt..."
        "$SCRIPT_DIR/setup-letsencrypt-wildcard.sh"
        ;;
    3)
        echo "🧹 Nettoyage et réinstallation..."
        "$SCRIPT_DIR/cleanup-nginx-configs.sh"
        echo "📄 Installation de la configuration de base..."
        "$SCRIPT_DIR/install-ayta-production.sh"
        ;;
    4)
        echo "🔍 Vérification de la configuration actuelle..."
        echo ""
        echo "📋 Configurations Nginx existantes:"
        ls -la "$NGINX_CONF_D"/*.conf 2>/dev/null || echo "Aucune configuration trouvée"
        echo ""
        echo "🧪 Test de la configuration Nginx:"
        nginx -t
        echo ""
        echo "📊 Statut de Nginx:"
        systemctl status nginx --no-pager -l
        echo ""
        echo "🌐 Test des domaines:"
        echo "• ayta.fr:"
        curl -I http://ayta.fr 2>/dev/null || echo "  ❌ Non accessible"
        echo "• www.ayta.fr:"
        curl -I http://www.ayta.fr 2>/dev/null || echo "  ❌ Non accessible"
        echo "• dev.ayta.fr:"
        curl -I http://dev.ayta.fr 2>/dev/null || echo "  ❌ Non accessible"
        ;;
    *)
        echo "❌ Choix invalide"
        exit 1
        ;;
esac

echo ""
echo "✅ Script terminé !"
