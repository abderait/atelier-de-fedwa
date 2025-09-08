#!/bin/bash

# Script de nettoyage des configurations Nginx
# Usage: sudo ./scripts/cleanup-nginx-configs.sh

echo "🧹 Nettoyage des configurations Nginx..."

# Vérifier que le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Veuillez exécuter ce script avec sudo"
    exit 1
fi

# Variables
NGINX_CONF_D="/etc/nginx/conf.d"
BACKUP_DIR="/etc/nginx/conf.d/backup-$(date +%Y%m%d-%H%M%S)"

echo "📁 Répertoire de configuration: $NGINX_CONF_D"
echo "💾 Sauvegarde dans: $BACKUP_DIR"

# 1. Créer un dossier de sauvegarde
echo "💾 Création de la sauvegarde..."
mkdir -p "$BACKUP_DIR"

# 2. Sauvegarder les configurations existantes
echo "📄 Sauvegarde des configurations existantes..."
cp "$NGINX_CONF_D"/*.conf "$BACKUP_DIR/" 2>/dev/null || true

# 3. Lister les configurations existantes
echo "📋 Configurations existantes:"
ls -la "$NGINX_CONF_D"/*.conf 2>/dev/null || echo "Aucune configuration trouvée"

# 4. Demander confirmation
echo ""
echo "⚠️  Ce script va nettoyer les configurations Nginx existantes."
echo "Une sauvegarde a été créée dans: $BACKUP_DIR"
echo ""
echo "Voulez-vous continuer ? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # 5. Supprimer les configurations existantes
    echo "🗑️  Suppression des configurations existantes..."
    rm -f "$NGINX_CONF_D"/*.conf
    
    # 6. Tester la configuration Nginx
    echo "🧪 Test de la configuration Nginx..."
    nginx -t
    
    if [ $? -eq 0 ]; then
        echo "✅ Configuration Nginx valide après nettoyage"
        
        # 7. Recharger Nginx
        echo "🔄 Rechargement de Nginx..."
        systemctl reload nginx
        
        if [ $? -eq 0 ]; then
            echo "✅ Nginx rechargé avec succès"
        else
            echo "❌ Erreur lors du rechargement de Nginx"
            exit 1
        fi
    else
        echo "❌ Configuration Nginx invalide après nettoyage"
        echo "🔄 Restauration de la sauvegarde..."
        cp "$BACKUP_DIR"/*.conf "$NGINX_CONF_D/" 2>/dev/null || true
        systemctl reload nginx
        exit 1
    fi
    
    echo ""
    echo "🎉 Nettoyage terminé !"
    echo "📁 Sauvegarde disponible dans: $BACKUP_DIR"
    echo ""
    echo "📋 Prochaines étapes:"
    echo "1. Exécutez le script Let's Encrypt:"
    echo "   sudo ./scripts/setup-letsencrypt-wildcard.sh"
    echo ""
    echo "2. Ou installez la configuration de base:"
    echo "   sudo ./scripts/install-nginx-ayta.sh"
    
else
    echo "❌ Nettoyage annulé"
    exit 1
fi
