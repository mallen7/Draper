#!/bin/bash

echo "********************************************************"
echo "Marketer; most ultimate scraper in the universe."
echo "********************************************************"
echo "Select an option to scrape:"

# Define the list of choices
options=("Option 1: Google Maps Scrape" "Option 2: Facebook Scrape" "Option 3: LinkedIn Scrape" "Option 4: Internet Email Domain Scrape" "Quit")

# Use the select command to create the menu
select opt in "${options[@]}"
do
    case $opt in
        "Google Maps Scrape")
            echo "You chose Option 1"
            ;;
        "Facebook Scrape")
            echo "You chose Option 2"
            ;;
        "LinkedIn Scrape")
            echo "You chose Option 3"
            ;;
        "Internet Email Domain Scrape")
            echo "You chose Option 3"
            ;;
        "Quit")
            break
            ;;
        *) echo "You fat fingered it, dingus. Try again. $REPLY";;
    esac
done