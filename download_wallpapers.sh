#!/bin/bash

# Define the URL to scrape
base_url="https://www.wallpaperflare.com/search?wallpaper=futuristic+city&page="
# Create the wallpapers directory if it doesn't exist
mkdir -p Wallpapers

# Extract links and save them to the CSV file
extract_image_urls() {
    local page_number=$1
    local page_url="${base_url}${page_number}"
    local image_urls=($(curl -s "$page_url" | grep -o 'itemprop="url" href="[^"]*"' | sed -e 's/itemprop="url" href="//g' -e 's/"//g'))
    
    for image_url in "${image_urls[@]}"; do
        echo "${image_url}/download" >> Wallpapers/image_urls.csv
    done

    echo "Extraction des URLs d'images de la page $page_number terminée."
}

# Extraction des URLs des images de la première page
extract_image_urls 1
total_pages=10

# Extraction des URLs des images des pages suivantes
for ((page=2; page<=total_pages; page++)); do
    extract_image_urls $page
done

echo "Extraction des URLs d'images de toutes les pages terminée. Les URLs sont enregistrées dans Wallpapers/image_urls.csv."