#!/bin/bash

# Script de configuration Let's Encrypt pour *.ayta.fr (wildcard certificate)
# Usage: sudo ./scripts/setup-letsencrypt-wildcard.sh

echo "🔐 Configuration Let's Encrypt pour *.ayta.fr..."

# Vérifier que le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Veuillez exécuter ce script avec sudo"
    exit 1
fi

# Variables
DOMAIN="ayta.fr"
WILDCARD_DOMAIN="*.ayta.fr"
EMAIL="abderait@ymail.com"  # Remplacez par votre email
NGINX_CONF_D="/etc/nginx/conf.d"
CONFIG_FILE="ayta.fr.conf"

echo "📧 Email pour Let's Encrypt: $EMAIL"
echo "🌐 Domaine: $DOMAIN"
echo "🔀 Wildcard: $WILDCARD_DOMAIN"

# 1. Installer Certbot et le plugin DNS
echo "📦 Installation de Certbot et des plugins..."
apt update
apt install -y certbot python3-certbot-nginx python3-certbot-dns-cloudflare

# 2. Vérifier que Nginx est installé et configuré
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx n'est pas installé"
    exit 1
fi

# 3. Créer une configuration Nginx temporaire pour la validation
echo "📄 Création de la configuration Nginx temporaire..."
cat > "$NGINX_CONF_D/$CONFIG_FILE" << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name ayta.fr www.ayta.fr *.ayta.fr;
    
    root /var/www/html;
    index index.html index.htm;
    
    # Logs
    access_log /var/log/nginx/ayta.fr.access.log;
    error_log /var/log/nginx/ayta.fr.error.log;
    
    # Configuration principale
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Let's Encrypt challenge
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
}
EOF

# 4. Configuration temporaire déjà active (conf.d)
echo "🔗 Configuration temporaire créée dans conf.d..."

# 5. Tester et recharger Nginx
echo "🧪 Test de la configuration Nginx..."
nginx -t
if [ $? -eq 0 ]; then
    systemctl reload nginx
    echo "✅ Configuration Nginx temporaire activée"
else
    echo "❌ Erreur dans la configuration Nginx"
    exit 1
fi

# 6. Demander les informations DNS
echo ""
echo "🔧 Configuration DNS requise pour la validation wildcard:"
echo "Vous devez configurer un enregistrement TXT dans votre DNS pour:"
echo "_acme-challenge.ayta.fr"
echo ""
echo "Voulez-vous continuer avec la validation manuelle ? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # 7. Générer le certificat wildcard
    echo "🔐 Génération du certificat wildcard..."
    certbot certonly \
        --manual \
        --preferred-challenges dns \
        --email "$EMAIL" \
        --agree-tos \
        --no-eff-email \
        -d "$DOMAIN" \
        -d "$WILDCARD_DOMAIN"
    
    if [ $? -eq 0 ]; then
        echo "✅ Certificat wildcard généré avec succès !"
        
        # 8. Créer la configuration Nginx finale avec SSL
        echo "📄 Création de la configuration Nginx finale avec SSL..."
        cat > "$NGINX_CONF_D/$CONFIG_FILE" << 'EOF'
# Redirection HTTP vers HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name ayta.fr www.ayta.fr *.ayta.fr;
    return 301 https://$server_name$request_uri;
}

# Configuration HTTPS
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ayta.fr www.ayta.fr *.ayta.fr;
    
    # Document root
    root /var/www/html;
    index index.html index.htm;
    
    # Logs
    access_log /var/log/nginx/ayta.fr.access.log;
    error_log /var/log/nginx/ayta.fr.error.log;
    
    # Configuration SSL
    ssl_certificate /etc/letsencrypt/live/ayta.fr/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ayta.fr/privkey.pem;
    
    # Configuration SSL moderne
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Headers de sécurité
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Configuration principale
    location / {
        try_files $uri $uri/ =404;
        
        # Headers de cache pour les assets statiques
        location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            add_header Vary Accept-Encoding;
        }
        
        # Headers de cache pour HTML
        location ~* \.html$ {
            expires 1h;
            add_header Cache-Control "public, must-revalidate";
        }
    }
    
    # Gestion des erreurs
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    
    # Sécurité - masquer la version Nginx
    server_tokens off;
    
    # Limitation de la taille des uploads
    client_max_body_size 10M;
    
    # Timeouts
    client_body_timeout 12;
    client_header_timeout 12;
    keepalive_timeout 15;
    send_timeout 10;
    
    # Compression Gzip
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;
}
EOF
        
        # 9. Recharger Nginx avec la nouvelle configuration
        echo "🔄 Rechargement de Nginx avec SSL..."
        nginx -t
        if [ $? -eq 0 ]; then
            systemctl reload nginx
            echo "✅ Configuration SSL activée !"
        else
            echo "❌ Erreur dans la configuration SSL"
            exit 1
        fi
        
        # 10. Configurer le renouvellement automatique
        echo "🔄 Configuration du renouvellement automatique..."
        (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
        echo "✅ Renouvellement automatique configuré"
        
        # 11. Tester le certificat
        echo "🧪 Test du certificat SSL..."
        echo "Test de ayta.fr:"
        curl -I https://ayta.fr
        echo ""
        echo "Test de www.ayta.fr:"
        curl -I https://www.ayta.fr
        
        echo ""
        echo "🎉 Configuration Let's Encrypt terminée !"
        echo ""
        echo "📋 Informations importantes:"
        echo "• Certificat wildcard: *.ayta.fr"
        echo "• Fichiers SSL: /etc/letsencrypt/live/ayta.fr/"
        echo "• Renouvellement automatique: configuré"
        echo "• Configuration Nginx: /etc/nginx/conf.d/ayta.fr.conf"
        echo ""
        echo "🔍 Vérification:"
        echo "• https://ayta.fr"
        echo "• https://www.ayta.fr"
        echo "• https://dev.ayta.fr (si configuré)"
        
    else
        echo "❌ Erreur lors de la génération du certificat"
        exit 1
    fi
else
    echo "❌ Configuration annulée"
    exit 1
fi
