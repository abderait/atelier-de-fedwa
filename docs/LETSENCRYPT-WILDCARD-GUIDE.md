# Guide Let's Encrypt Wildcard pour *.ayta.fr

## 🎯 Objectif
Configurer un certificat SSL wildcard `*.ayta.fr` pour sécuriser tous les sous-domaines d'ayta.fr.

## 📋 Prérequis
- Serveur VPS avec Nginx installé
- Domaine `ayta.fr` configuré
- Accès root au serveur
- DNS configuré pour `ayta.fr` et `*.ayta.fr`

## 🔧 Méthodes de configuration

### Méthode 1 : Validation DNS manuelle (Recommandée)

#### 1.1 Installation
```bash
# Sur votre serveur VPS
sudo ./scripts/setup-letsencrypt-wildcard.sh
```

#### 1.2 Configuration DNS requise
Pendant l'exécution, vous devrez créer un enregistrement TXT :
- **Nom** : `_acme-challenge.ayta.fr`
- **Valeur** : (fournie par Certbot)
- **TTL** : 300 (5 minutes)

#### 1.3 Avantages
- ✅ Pas besoin de compte Cloudflare
- ✅ Fonctionne avec n'importe quel fournisseur DNS
- ✅ Contrôle total du processus

### Méthode 2 : Validation DNS automatique avec Cloudflare

#### 2.1 Préparation Cloudflare
1. Connectez-vous à votre compte Cloudflare
2. Allez dans **My Profile** → **API Tokens**
3. Créez un token avec les permissions :
   - `Zone:Zone:Read`
   - `Zone:DNS:Edit`
4. Notez votre email et le token

#### 2.2 Installation
```bash
# Sur votre serveur VPS
sudo ./scripts/setup-letsencrypt-cloudflare.sh
```

#### 2.3 Configuration
Éditez le fichier `/etc/letsencrypt/cloudflare.ini` :
```ini
dns_cloudflare_email = votre-email@example.com
dns_cloudflare_api_key = votre-token-cloudflare
```

#### 2.4 Avantages
- ✅ Automatique (pas d'intervention manuelle)
- ✅ Renouvellement automatique
- ✅ Idéal pour l'automatisation

## 🚀 Instructions détaillées

### Étape 1 : Préparation du serveur
```bash
# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer Nginx si pas déjà fait
sudo apt install nginx -y

# Vérifier que Nginx fonctionne
sudo systemctl status nginx
```

### Étape 2 : Configuration DNS
#### Pour OVH (votre fournisseur actuel) :
1. Connectez-vous à votre espace client OVH
2. Allez dans **Web Cloud** → **Domaines** → **ayta.fr**
3. Cliquez sur **Zone DNS**
4. Ajoutez un enregistrement TXT :
   - **Sous-domaine** : `_acme-challenge`
   - **Valeur** : (sera fournie par Certbot)
   - **TTL** : 300

### Étape 3 : Exécution du script
```bash
# Méthode manuelle
sudo ./scripts/setup-letsencrypt-wildcard.sh

# OU méthode Cloudflare
sudo ./scripts/setup-letsencrypt-cloudflare.sh
```

### Étape 4 : Vérification
```bash
# Tester le certificat
curl -I https://ayta.fr
curl -I https://www.ayta.fr

# Vérifier les détails du certificat
openssl s_client -connect ayta.fr:443 -servername ayta.fr
```

## 🔍 Dépannage

### Problème : "DNS propagation"
```bash
# Vérifier la propagation DNS
dig TXT _acme-challenge.ayta.fr
nslookup _acme-challenge.ayta.fr
```

### Problème : "Nginx configuration error"
```bash
# Tester la configuration
sudo nginx -t

# Voir les erreurs détaillées
sudo nginx -T
```

### Problème : "Certificate generation failed"
```bash
# Vérifier les logs
sudo tail -f /var/log/letsencrypt/letsencrypt.log

# Nettoyer et recommencer
sudo certbot delete --cert-name ayta.fr
```

## 📁 Fichiers créés

### Configuration Nginx
- `/etc/nginx/conf.d/ayta.fr.conf`

### Certificats SSL
- `/etc/letsencrypt/live/ayta.fr/fullchain.pem`
- `/etc/letsencrypt/live/ayta.fr/privkey.pem`

### Configuration Cloudflare (si utilisé)
- `/etc/letsencrypt/cloudflare.ini`

## 🔄 Renouvellement automatique

Le script configure automatiquement le renouvellement via cron :
```bash
# Vérifier la tâche cron
sudo crontab -l

# Tester le renouvellement
sudo certbot renew --dry-run
```

## 🎯 Résultat final

Après configuration, vous aurez :
- ✅ `https://ayta.fr` - Site principal
- ✅ `https://www.ayta.fr` - Version www
- ✅ `https://dev.ayta.fr` - Site de développement
- ✅ `https://api.ayta.fr` - API (si configuré)
- ✅ `https://admin.ayta.fr` - Administration (si configuré)

## 🆘 Support

En cas de problème :
1. Vérifiez les logs : `sudo tail -f /var/log/nginx/error.log`
2. Testez la configuration : `sudo nginx -t`
3. Vérifiez les certificats : `sudo certbot certificates`
4. Consultez la documentation Let's Encrypt : https://letsencrypt.org/docs/

## 📚 Ressources utiles

- [Documentation Let's Encrypt](https://letsencrypt.org/docs/)
- [Certbot Documentation](https://certbot.eff.org/docs/)
- [Nginx SSL Configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [Cloudflare API Documentation](https://developers.cloudflare.com/api/)
