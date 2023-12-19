#!/bin/bash

# Source the environment variables
source ../src/env.sh

# Grabbing PID variable
export pid=$(cat ./work/${proj_name}/pid.txt)

export proj_name=$1
export fuid=$2

export gmaps_output="../work/${proj_name}/full_scrape_${pid}.csv"
export dirty_email="../work/${proj_name}/dirty_${pid}.csv"
export clean_email_csv="../work/${proj_name}/clean_${pid}.csv"
export clean_email_txt="../work/${proj_name}/clean_${pid}.txt"
export scraped_emails="../work/${proj_name}/scraped_emails_${pid}.csv"

export subject="Draper; Google Maps/Email Domain Scraper Results ${proj_name}"

# User prompts
read -rp "Enter Google Maps Scraper query: " query
read -rp "Enter email address to send output to: " email

# Google Maps scraper
echo "Running Google Maps Scraper..."
cd ../proj/google-maps-scraper || return
python3 ./main.py "${query}"
cd ../..

# Get latest Google Maps query output
echo "Pulling scraper output..."
find "../proj/google-maps-scraper/output" -type f -name "*.csv" -not -path "proj/google-maps-scraper/output/all/*" -print0 | xargs -0 ls -t | head -n 1 | xargs -I '{}' cp -fr '{}' ${gmaps_output}
if [ $? -ne 0 ]; then
    echo "Error occurred in find or copy command"
fi

# Cut out the domain column and create new file
echo "Performing ETL operations..."
cd work/"${proj_name}" || return
cut -d',' -f6 "${gmaps_output}" >> "${dirty_email}"

# Clean the extracted domains
echo "Cleaning extracted domains..."
./src/domain-cleaner.sh "${dirty_email}" "${proj_name}"
cd work/"${proj_name}"/ || return
cp "${clean_email}" "${clean_email_txt}"
cp "${clean_email_txt}" "../proc/email_scrape_tmp.txt"

# Crawl domains for more emails
echo "Crawling domains for more emails..."
email_crawl "${clean_email_txt}"
cp "../proc/email_results_tmp.txt" "${scraped_emails}"

# Zipping files
echo "Zipping files..."
zip -r "${proj_name}.zip" "${gmaps_output}" "${clean_email_csv}" "${scraped_emails}"

# Emailing results
echo "Emailing results..."
mail_output "${subject}" "${email}" "${proj_name}"