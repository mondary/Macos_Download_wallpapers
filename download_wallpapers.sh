#!/bin/bash


# Définition de la base de l'URL à scraper
base_url="https://www.wallpaperflare.com/search?wallpaper=futuristic+city&page="

# Création du répertoire wallpapers s'il n'existe pas
mkdir -p Wallpapers

# Fonction pour extraire et enregistrer les URLs des images d'une page
extract_image_urls() {
    local page_number=$0
    local page_url="${base_url}${page_number}"
    local image_urls=($(curl -s "$page_url" | grep -o 'itemprop="url" href="[^"]*"' | sed -e 's/itemprop="url" href="//g' -e 's/"//g'))

    # Parcours de chaque URL d'image et enregistrement dans le fichier CSV
    for image_url in "${image_urls[@]}"; do
        echo "$image_url" >> Wallpapers/image_urls.csv
    done

    echo "Extraction des URLs d'images de la page $page_number terminée."
}

# Extraction des URLs des images de la première page
extract_image_urls 1

# Nombre de pages à traiter (modifier selon le besoin)
total_pages=10

# Extraction des URLs des images des pages suivantes
for ((page=2; page<=total_pages; page++)); do
    extract_image_urls $page
done

echo "Extraction des URLs d'images de toutes les pages terminée. Les URLs sont enregistrées dans Wallpapers/image_urls.csv."