#!/bin/bash

# Source the environment variables
source ./src/env.sh

# Purge previous ./work directory with echo off
set +x
trunc_work

echo "**********************************************"
echo "Draper; most ultimate scraper in the universe."
echo "**********************************************"

read -p "Enter a project name: " project_name

# Create the project directory
cr_proj_dir "$project_name"

echo "Select an option to scrape:"

# Define the list of scraping choices
options=("Option 1: Google Maps Scrape" "Option 2: Facebook Scrape" "Option 3: LinkedIn Scrape" "Option 4: Internet Email Domain Scrape" "Quit")

# Use the select command to create the menu
select opt in "${options[@]}"
do
    case $opt in
        "Option 1: Google Maps Scrape")
            echo "You chose Google Maps Scrape"
            cp -p "./src/google-maps-scrape.sh ./work/"${project_name}"/"
            sh "./work/${project_name}/google-maps-scrape.sh "${project_name}" "${fuid}""
            ;;
        "Option 2: Facebook Scrape")
            echo "You chose Facebook Scrape"
            ;;
        "Option 3: LinkedIn Scrape")
            echo "You chose LinkedIn Scrape"
            ;;
        "Option 4: Internet Email Domain Scrape")
            echo "You chose Internet Email Domain Scrape"
            ;;
        "Quit")
            cat src/buddha.txt
            sleep 5
            break
            ;;
        *) echo "You fat fingered it, dingus. Try again. $REPLY";;
    esac
done

