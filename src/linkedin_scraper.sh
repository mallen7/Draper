#!/bin/bash

# Source the environment variables
source "src/env.sh"

# Exports
export proj_name=$1

# Grabbing PID variable
export pid=$(cat work/${proj_name}/pid.txt)
cat $pid

# Get user inputs
read -rp "Enter target industry: " industry
read -rp "Enter target region: " region

# Run the LinkedIn scraper
echo "Running LinkedIn scraper..."
cd proj/scrapedin
python3 scrapedin.py -i "${industry}" -g "${region}" -o "work/linkedin_scrape_${pid}.csv"