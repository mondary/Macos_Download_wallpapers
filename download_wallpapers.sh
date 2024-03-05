#!/bin/bash

base_url="https://www.wallpaperflare.com/search?wallpaper=futuristic+city&page="
# Créer le répertoire Wallpapers s'il n'existe pas
mkdir -p Wallpapers

# Fonction pour extraire les URLs des images à partir d'une page donnée
extract_image_urls() {
    local page_number=$1
    local page_url="${base_url}${page_number}"
    # Extraire les URLs des images de la page en cours
    local image_urls=($(curl -s "$page_url" | grep -o 'itemprop="url" href="[^"]*"' | sed -e 's/itemprop="url" href="//g' -e 's/"//g'))
    
    # Parcourir les URLs des images et les ajouter au fichier image_urls.csv
    for image_url in "${image_urls[@]}"; do
        echo "${image_url}/download" >> Wallpapers/images_futuristic+city.csv
    done

    echo "Extraction des URLs d'images de la page $page_number terminée."
}

# Extraction des URLs des images de la première page
extract_image_urls 1
total_pages=10

# Boucler à travers les pages pour extraire les URLs des images
for ((page=2; page<=total_pages; page++)); do
    extract_image_urls $page
done

echo "Extraction des URLs d'images de toutes les pages terminée. Les URLs sont enregistrées dans Wallpapers/images_futuristic+city.csv."

# Fonction pour lister les images à partir des URLs se terminant par "/download" en excluant ceux contenant "thumb", "preview" et "logo.svg"
list_images_from_url() {
    local link=$1
    local image_urls=($(curl -s "$link" | grep -o '<img[^>]*src="[^"]*"[^>]*>' | sed -e 's/<img[^>]*src="//g' -e 's/"[^>]*>//g'))
    
    for image_url in "${image_urls[@]}"; do
        if [[ $image_url != *"-thumb"* && $image_url != *"-preview"* && $image_url != *"logo.svg" ]]; then
            filename=$(basename "$image_url")
            curl -s "$image_url" -o "Wallpapers/$filename"
        fi
    done
}

# Lire les URLs se terminant par "/download" à partir du fichier CSV
while IFS= read -r image_url; do
    list_images_from_url "$image_url"
done < Wallpapers/images_futuristic+city.csv

echo "Liste des fichiers images obtenue. Les fichiers sont enregistrés dans Wallpapers."

# Renommer le fichier CSV en images_futuristic+city.csv
mv Wallpapers/images_futuristic+city.csv Wallpapers/images_futuristic+city.csv

echo "Le fichier CSV a été renommé en images_futuristic+city.csv."
