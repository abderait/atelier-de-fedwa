# 🚀 Guide de Déploiement - L'Atelier de Fedwa

## 📋 Prérequis
- Serveur Ubuntu/Debian avec Nginx
- Accès root/sudo
- Git installé
- Nom de domaine configuré : `dev.consultantdigital-paris.fr`

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

### 3. Configurer Nginx
```bash
sudo cp nginx-dev.conf /etc/nginx/sites-available/dev.consultantdigital-paris.fr
sudo ln -s /etc/nginx/sites-available/dev.consultantdigital-paris.fr /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Déploiement automatique
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
- URL : http://dev.consultantdigital-paris.fr
- Protection : Mot de passe requis
- Indexation : Bloquée par robots.txt

## 🛠️ Maintenance
- Logs Nginx : `/var/log/nginx/dev.consultantdigital-paris.fr.*.log`
- Test config : `sudo nginx -t`
- Redémarrage : `sudo systemctl reload nginx`
