# 🎂 L'Atelier de Fedwa

Site vitrine pour les pâtisseries artisanales de L'Atelier de Fedwa.

## 🚀 Démarrage rapide

### Développement
```bash
# Cloner le projet
git clone https://github.com/abderait/atelier-de-fedwa.git
cd atelier-de-fedwa

# Construire la version de production
./scripts/build.sh

# Les fichiers sont générés dans le dossier dist/
```

### Production
```bash
# Déployer sur le serveur
cd /var/www/dev
git pull origin main
sudo systemctl reload nginx
```

## 📁 Structure du projet

```
patisserie/
├── src/                          # Code source
│   ├── assets/                   # Ressources statiques
│   │   ├── images/              # Images du projet
│   │   ├── icons/               # Icônes et logos
│   │   └── fonts/               # Polices personnalisées
│   ├── css/                     # Feuilles de style
│   │   ├── main.css             # Styles principaux
│   │   ├── components/          # Styles des composants
│   │   └── responsive/          # Media queries
│   ├── js/                      # Scripts JavaScript
│   │   └── main.js              # Script principal
│   └── pages/                   # Pages HTML
│       ├── index.html           # Page d'accueil
│       ├── galerie-gateaux.html
│       ├── galerie-desserts.html
│       └── galerie-occasions.html
├── dist/                        # Version de production
├── docs/                        # Documentation
├── scripts/                     # Scripts de déploiement
└── README.md                    # Ce fichier
```

## 🛠️ Technologies

- **HTML5** - Structure sémantique
- **CSS3** - Styles et animations
- **JavaScript Vanilla** - Interactivité
- **Nginx** - Serveur web
- **Git** - Versioning

## 📱 Fonctionnalités

- ✅ Design responsive (mobile-first)
- ✅ Galerie interactive avec slider
- ✅ Navigation mobile avec menu hamburger
- ✅ Optimisations CLS (Cumulative Layout Shift)
- ✅ Versioning des assets pour le cache
- ✅ Animations fluides et performantes

## 🔧 Configuration

### Serveur de production
- **URL** : dev.ayta.fr
- **Serveur** : 5.182.18.4
- **Répertoire** : /var/www/dev
- **Configuration Nginx** : /etc/nginx/conf.d/dev.ayta.fr.conf

### Versioning des assets
Les fichiers CSS et JS sont versionnés automatiquement :
- `main.css?v=20241207231500`
- `main.js?v=20241207231500`

## 📚 Documentation

- [Documentation complète](PROJECT-DOCUMENTATION.md)
- [Guide de déploiement](docs/README-DEPLOYMENT.md)

## 🎨 Design System

### Couleurs
- **Or principal** : #d4af37
- **Or clair** : #f4d03f
- **Gris foncé** : #2c2c2c
- **Gris moyen** : #6a6a6a

### Typographie
- **Titres** : Playfair Display
- **Corps** : Open Sans

## 🚀 Déploiement

### Automatique
```bash
./scripts/build.sh
```

### Manuel
```bash
# Copier les fichiers de src/ vers dist/
# Mettre à jour les chemins dans les HTML
# Déployer dist/ sur le serveur
```

## 📞 Contact

**Développeur** : AIT HAMMOU Abderrahim  
**Repository** : https://github.com/abderait/atelier-de-fedwa.git

---

*Dernière mise à jour : $(date)*
