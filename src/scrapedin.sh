#!/bin/bash

# Source the environment variables
source "src/env.sh"

# Exports
export proj_name=$1

# Grabbing PID variable
export pid=$(cat work/${proj_name}/pid.txt)

# Get user inputs
read -rp "Enter target industry: " industry
read -rp "Enter target region: " region

# Run the LinkedIn scraper
echo "Running LinkedIn scraper..."
python3 proj/scraped_in/scrapedin.py -i "${industry}" -g "${region}" -o "work/linkedin_scrape_${pid}.csv" -u sallen68584@gmail.com