#!/bin/bash

# Script d'installation de la configuration Nginx pour ayta.fr (Production)
# Usage: sudo ./scripts/install-ayta-production.sh

echo "🚀 Installation de la configuration Nginx pour ayta.fr (Production)..."

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
echo "📁 Répertoire de configuration: $NGINX_CONF_D"

# 1. Vérifier que le répertoire /var/www/html existe
if [ ! -d "/var/www/html" ]; then
    echo "📁 Création du répertoire /var/www/html..."
    mkdir -p /var/www/html
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

# 2. Créer une page d'accueil temporaire si elle n'existe pas
if [ ! -f "/var/www/html/index.html" ]; then
    echo "📄 Création d'une page d'accueil temporaire..."
    cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ayta.fr - Site en construction</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 600px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        .status {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .links {
            margin-top: 30px;
        }
        .links a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .links a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Ayta.fr</h1>
        <p>Site en construction</p>
        
        <div class="status">
            <h3>✅ Configuration Nginx active</h3>
            <p>Le serveur est opérationnel et prêt pour le déploiement</p>
        </div>
        
        <div class="links">
            <a href="https://dev.ayta.fr" target="_blank">Site de développement</a>
            <a href="mailto:abderait@ymail.com">Contact</a>
        </div>
        
        <p style="margin-top: 30px; font-size: 0.9rem; opacity: 0.7;">
            Dernière mise à jour: $(date)
        </p>
    </div>
</body>
</html>
EOF
    echo "✅ Page d'accueil temporaire créée"
fi

# 3. Copier la configuration Nginx
echo "📄 Copie de la configuration Nginx..."
cp "$SCRIPT_DIR/nginx-ayta-production.conf" "$NGINX_CONF_D/$CONFIG_FILE"

# 4. Tester la configuration
echo "🧪 Test de la configuration Nginx..."
nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Configuration Nginx valide"
    
    # 5. Recharger Nginx
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

# 6. Vérifier le statut
echo "📊 Statut de Nginx:"
systemctl status nginx --no-pager -l

echo ""
echo "🎉 Installation terminée !"
echo ""
echo "📋 Informations:"
echo "• Site principal: http://ayta.fr"
echo "• Site www: http://www.ayta.fr"
echo "• Répertoire: /var/www/html"
echo "• Configuration: /etc/nginx/conf.d/ayta.fr.conf"
echo "• Logs: /var/log/nginx/ayta.fr.access.log"
echo ""
echo "🔍 Vérification:"
echo "• curl -I http://ayta.fr"
echo "• curl -I http://www.ayta.fr"
echo ""
echo "📝 Prochaines étapes:"
echo "1. Configurez Let's Encrypt pour HTTPS:"
echo "   sudo ./scripts/setup-letsencrypt-wildcard.sh"
echo ""
echo "2. Déployez votre site dans /var/www/html/"
echo ""
echo "3. Consultez les logs si nécessaire:"
echo "   sudo tail -f /var/log/nginx/ayta.fr.access.log"
