# 🚀 Guide de Déploiement - L'Atelier de Fedwa

## 📋 Prérequis
- Serveur Ubuntu/Debian avec Nginx
- Accès root/sudo
- Git installé
- Nom de domaine configuré : `dev.ayta.fr`

## 🔧 Installation

### 1. Télécharger les fichiers
```bash
cd /var/www
git clone https://github.com/abderait/atelier-de-fedwa.git dev
cd dev
```

### 2. Créer le fichier de mot de passe
```bash
# Le mot de passe est déjà configuré : admin$
# Utilisateur : admin
# Mot de passe : admin$
```

### 3. Configurer Nginx (Configuration simplifiée)
```bash
# Créer la configuration Nginx simplifiée
sudo nano /etc/nginx/conf.d/dev.ayta.fr.conf
```

**Contenu de la configuration :**
```nginx
server {
    listen 80;
    server_name dev.ayta.fr;
    root /var/www/dev;
    index index.html index.htm;
    
    # Logs
    access_log /var/log/nginx/dev.ayta.fr.access.log;
    error_log /var/log/nginx/dev.ayta.fr.error.log;
    
    # Protection par mot de passe
    auth_basic "Site en développement - Accès restreint";
    auth_basic_user_file /var/www/dev/.htpasswd;
    
    # Configuration principale
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Optimisation des fichiers statiques
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1M;
        add_header Cache-Control "public, immutable";
    }
}
```

### 4. Tester et activer
```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Déploiement automatique (optionnel)
```bash
./deploy.sh
```

## 🔐 Sécurité

### Protection par mot de passe
- Fichier : `/var/www/dev/.htpasswd`
- Utilisateur par défaut : `admin`
- Mot de passe : `admin$`
- Pour ajouter un utilisateur : `sudo htpasswd /var/www/dev/.htpasswd nouvel_utilisateur`

### Robots.txt
- Bloque complètement l'indexation
- Fichier : `/var/www/dev/robots.txt`

## ⚠️ Résolution de problèmes

### Problème de proxy (502 Bad Gateway)
Si vous rencontrez une erreur 502, vérifiez qu'il n'y a pas de configurations de proxy qui interfèrent :

```bash
# Vérifier les configurations actives
sudo nginx -T | grep -i proxy
sudo nginx -T | grep -i "8080"

# Supprimer les configurations qui font du proxy
sudo rm /etc/nginx/conf.d/5.182.18.4.conf
sudo rm /etc/nginx/conf.d/agents.conf
sudo rm /etc/nginx/conf.d/phpmyadmin.inc
sudo rm /etc/nginx/conf.d/phppgadmin.inc
sudo rm /etc/nginx/conf.d/status.conf

# Redémarrer Nginx
sudo systemctl restart nginx
```

### Test de l'authentification
```bash
# Test avec curl (échapper le symbole $)
curl -u 'admin:admin$' http://dev.ayta.fr

# Ou utiliser des guillemets doubles
curl -u "admin:admin$" http://dev.ayta.fr
```

## 📁 Structure des fichiers
```
/var/www/dev/
├── index.html
├── styles.css
├── script.js
├── robots.txt
├── .htaccess
├── .htpasswd
├── nginx-dev.conf
└── deploy.sh
```

## 🔄 Mise à jour
```bash
cd /var/www/dev
git pull origin main
sudo systemctl reload nginx
```

## 🌐 Accès
- **URL** : http://dev.ayta.fr
- **Protection** : Mot de passe requis (admin / admin$)
- **Indexation** : Bloquée par robots.txt
- **Status** : ✅ Fonctionnel et sécurisé

## 🛠️ Maintenance
- **Logs Nginx** : `/var/log/nginx/dev.ayta.fr.*.log`
- **Test config** : `sudo nginx -t`
- **Redémarrage** : `sudo systemctl reload nginx`
- **Vérification** : `curl -I http://dev.ayta.fr`

## 📊 Statut du déploiement
- ✅ Site accessible et fonctionnel
- ✅ Protection par mot de passe active
- ✅ Configuration Nginx optimisée
- ✅ Fichiers déployés correctement
- ✅ Logs configurés
- ✅ Performance optimisée
