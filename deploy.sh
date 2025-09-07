#!/bin/bash

# Script de déploiement pour dev.consultantdigital-paris.fr
# Usage: ./deploy.sh

set -e

echo "🚀 Déploiement du site L'Atelier de Fedwa..."

# Variables
REPO_URL="https://github.com/abderait/atelier-de-fedwa.git"
DEPLOY_DIR="/var/www/dev"
NGINX_CONF="/etc/nginx/sites-available/dev.consultantdigital-paris.fr"
NGINX_ENABLED="/etc/nginx/sites-enabled/dev.consultantdigital-paris.fr"

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📁 Création du répertoire de déploiement...${NC}"
sudo mkdir -p $DEPLOY_DIR

echo -e "${YELLOW}📥 Clonage/Mise à jour du repository...${NC}"
if [ -d "$DEPLOY_DIR/.git" ]; then
    cd $DEPLOY_DIR
    sudo git pull origin main
else
    sudo git clone $REPO_URL $DEPLOY_DIR
    cd $DEPLOY_DIR
fi

echo -e "${YELLOW}🔧 Configuration des permissions...${NC}"
sudo chown -R www-data:www-data $DEPLOY_DIR
sudo chmod -R 755 $DEPLOY_DIR

echo -e "${YELLOW}🔐 Création du fichier .htpasswd...${NC}"
if [ ! -f "$DEPLOY_DIR/.htpasswd" ]; then
    echo "Création du fichier .htpasswd avec le mot de passe admin$..."
    echo "admin:\$apr1\$r1/7K8OG\$m6z3bVwsw7yrJxKp5X6fH0" > $DEPLOY_DIR/.htpasswd
    echo "Fichier .htpasswd créé avec succès !"
fi

echo -e "${YELLOW}⚙️ Configuration Nginx...${NC}"
sudo cp nginx-dev.conf $NGINX_CONF
sudo ln -sf $NGINX_CONF $NGINX_ENABLED

echo -e "${YELLOW}🔍 Test de la configuration Nginx...${NC}"
sudo nginx -t

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Configuration Nginx valide${NC}"
    echo -e "${YELLOW}🔄 Redémarrage de Nginx...${NC}"
    sudo systemctl reload nginx
    echo -e "${GREEN}✅ Nginx redémarré avec succès${NC}"
else
    echo -e "${RED}❌ Erreur dans la configuration Nginx${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Déploiement terminé avec succès !${NC}"
echo -e "${YELLOW}🌐 Site accessible sur: http://dev.consultantdigital-paris.fr${NC}"
echo -e "${YELLOW}🔐 Protection par mot de passe activée${NC}"
echo -e "${YELLOW}🤖 Robots.txt configuré pour bloquer l'indexation${NC}"
