# 🎂 L'Atelier de Fedwa - Documentation Projet

## 📋 **Vue d'ensemble du projet**

**Site web** : Pâtisseries artisanales de L'Atelier de Fedwa  
**URL de production** : `dev.ayta.fr`  
**Type** : Site vitrine statique avec galerie interactive  
**Technologies** : HTML5, CSS3, JavaScript Vanilla, Nginx  

---

## 🏗️ **Architecture du projet**

### **Structure des dossiers (recommandée)**
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
│   │   ├── main.js              # Script principal
│   │   ├── gallery.js           # Fonctionnalités galerie
│   │   └── navigation.js        # Menu mobile
│   └── pages/                   # Pages HTML
│       ├── index.html           # Page d'accueil
│       ├── galerie-gateaux.html
│       ├── galerie-desserts.html
│       └── galerie-occasions.html
├── dist/                        # Version de production
├── docs/                        # Documentation
├── scripts/                     # Scripts de déploiement
└── README.md                    # Documentation principale
```

---

## 🎨 **Design System**

### **Charte graphique**
- **Couleurs principales** :
  - Or : `#d4af37` (boutons, accents)
  - Or clair : `#f4d03f` (gradients)
  - Gris foncé : `#2c2c2c` (textes)
  - Gris moyen : `#6a6a6a` (sous-textes)
  - Blanc : `#fefefe` (arrière-plans)

### **Typographie**
- **Titres** : Playfair Display (serif)
- **Corps** : Open Sans (sans-serif)
- **Tailles** : 3.8rem (titre), 1.8rem (sous-titre), 1.2rem (corps)

### **Composants**
- **Boutons** : Border-radius 50px, padding 12px 30px
- **Cartes** : Border-radius 15px, box-shadow
- **Animations** : slideInLeftOptimized, délais échelonnés

---

## 🚀 **Fonctionnalités**

### **Page d'accueil**
- Hero section avec titre animé
- Section "À propos" (3 colonnes)
- Galerie interactive avec cartes cliquables
- Section contact avec réseaux sociaux

### **Pages galerie**
- Slider d'images avec navigation
- Miniatures cliquables
- Navigation clavier (flèches)
- Call-to-action "Demander un devis"

### **Responsive Design**
- Mobile-first approach
- Breakpoints : 768px, 480px, 375px
- Menu hamburger sur mobile
- Optimisations CLS (Cumulative Layout Shift)

---

## 🔧 **Configuration technique**

### **Serveur de production**
- **OS** : Ubuntu 18.04.6 LTS
- **Web Server** : Nginx
- **Répertoire** : `/var/www/dev`
- **Configuration** : `/etc/nginx/conf.d/dev.ayta.fr.conf`

### **Versioning des assets**
- **CSS** : `styles.css?v=1.2.0`
- **JS** : `script.js?v=1.2.0`
- **Mise à jour** : Incrémenter la version à chaque modification

### **Optimisations**
- **Cache** : 1 mois pour les assets statiques
- **Compression** : GZIP activé
- **Images** : Optimisées via Unsplash avec paramètres
- **CLS** : min-height réservé pour éviter les décalages

---

## 📱 **Pages et navigation**

### **Structure de navigation**
```
Accueil (#accueil)
├── À propos (#apropos)
├── Galerie (#galerie)
│   ├── Gâteaux (galerie-gateaux.html)
│   ├── Desserts (galerie-desserts.html)
│   └── Occasions spéciales (galerie-occasions.html)
└── Contact (#contact)
```

### **Liens externes**
- **Instagram** : @latelier_de_fedwa
- **TikTok** : @latelierdefedwa67
- **Email** : contact@latelierdefedwa.com

---

## 🛠️ **Développement**

### **Commandes Git utiles**
```bash
# Mise à jour depuis GitHub
git pull origin main

# Ajout des modifications
git add .
git commit -m "Description des modifications"
git push origin main

# Vérification du statut
git status
git log --oneline -5
```

### **Déploiement**
```bash
# Connexion au serveur
ssh root@5.182.18.4

# Mise à jour du code
cd /var/www/dev
git pull origin main

# Rechargement Nginx
sudo systemctl reload nginx
```

---

## 🐛 **Problèmes résolus**

### **Menu hamburger mobile**
- **Problème** : Menu invisible sur mobile
- **Solution** : Styles spécifiques avec `!important` et z-index élevé
- **CSS** : `@media (max-width: 768px)` avec `display: flex !important`

### **CLS (Cumulative Layout Shift)**
- **Problème** : Décalages visuels lors des animations
- **Solution** : `min-height` réservé pour tous les éléments animés
- **Animation** : `slideInLeftOptimized` avec délais échelonnés

### **Cache navigateur**
- **Problème** : Modifications CSS non prises en compte
- **Solution** : Versioning des assets (`?v=1.2.0`)
- **Mise à jour** : Incrémenter la version à chaque modification

---

## 📊 **Métriques et performances**

### **Optimisations appliquées**
- ✅ **CLS = 0** (pas de décalages de layout)
- ✅ **Images optimisées** (Unsplash avec paramètres)
- ✅ **CSS minifié** et organisé
- ✅ **JavaScript vanilla** (pas de dépendances)
- ✅ **Cache navigateur** optimisé

### **Responsive breakpoints**
- **Desktop** : > 768px
- **Tablet** : ≤ 768px
- **Mobile** : ≤ 480px
- **Small Mobile** : ≤ 375px

---

## 🔐 **Sécurité et maintenance**

### **Fichiers de configuration**
- **Nginx** : `/etc/nginx/conf.d/dev.ayta.fr.conf`
- **HTAccess** : Supprimé (protection retirée)
- **Logs** : `/var/log/nginx/dev.ayta.fr.*.log`

### **Maintenance**
- **Backup** : Code sur GitHub
- **Monitoring** : Logs Nginx
- **Updates** : Via Git pull
- **Security** : Headers de sécurité dans Nginx

---

## 📞 **Contact et support**

**Développeur** : AIT HAMMOU Abderrahim  
**Email** : abderait@MacBook-Pro-de-Admin.local  
**Repository** : https://github.com/abderait/atelier-de-fedwa.git  
**Serveur** : 5.182.18.4 (dev.ayta.fr)  

---

## 📝 **Notes de développement**

### **Dernières modifications**
- ✅ Galerie interactive avec pages dédiées
- ✅ Système de slider avec navigation
- ✅ Call-to-action "Demander un devis"
- ✅ Optimisations CLS et performance
- ✅ Menu hamburger corrigé
- ✅ Versioning des assets

### **Prochaines améliorations possibles**
- [ ] Système de gestion d'images (admin panel)
- [ ] Formulaire de contact fonctionnel
- [ ] Optimisations SEO avancées
- [ ] Tests de performance
- [ ] Monitoring en temps réel

---

*Dernière mise à jour : $(date)*
*Version du projet : 1.2.0*
