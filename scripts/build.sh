#!/bin/bash

# Script de build pour L'Atelier de Fedwa
# Génère la version de production dans le dossier dist/

echo "🏗️  Building L'Atelier de Fedwa..."

# Créer le dossier dist s'il n'existe pas
mkdir -p dist

# Copier les fichiers HTML
echo "📄 Copying HTML files..."
cp src/pages/index.html dist/
cp src/pages/index.html .  # Garder index.html à la racine

# Copier les fichiers CSS
echo "🎨 Copying CSS files..."
cp src/css/*.css dist/
cp src/css/main.css styles.css  # Garder styles.css à la racine

# Copier les fichiers JS
echo "⚡ Copying JS files..."
cp src/js/*.js dist/
cp src/js/main.js script.js  # Garder script.js à la racine

# Copier les assets
echo "🖼️  Copying assets..."
cp -r src/assets/* dist/ 2>/dev/null || true

# Copier les fichiers de configuration
echo "⚙️  Copying config files..."
cp robots.txt dist/ 2>/dev/null || true

# Mettre à jour les chemins dans les fichiers HTML
echo "🔗 Updating file paths..."

# Remplacer les chemins CSS
find dist -name "*.html" -exec sed -i '' 's|href="styles.css|href="main.css|g' {} \;

# Remplacer les chemins JS
find dist -name "*.html" -exec sed -i '' 's|src="script.js|src="main.js|g' {} \;

# Ajouter le versioning
VERSION=$(date +%Y%m%d%H%M)
echo "📦 Adding version $VERSION..."

# Mettre à jour les liens CSS avec version
find dist -name "*.html" -exec sed -i '' "s|href=\"main.css|href=\"main.css?v=$VERSION|g" {} \;

# Mettre à jour les liens JS avec version
find dist -name "*.html" -exec sed -i '' "s|src=\"main.js|src=\"main.js?v=$VERSION|g" {} \;

echo "✅ Build completed successfully!"
echo "📁 Production files are in the 'dist' folder"
echo "🚀 Ready for deployment!"
