#!/bin/bash
source ./src/env.sh

export subject=$1
export email=$2
export proj_name=$3

echo "Send email on Mac or Linux?"

# Define the list of email
options=("Option 1: Mac" "Option 2: Linux" "Quit")

# Use the select command to create the menu
select opt in "${options[@]}"
do
    case $opt in
        "Option 1: Mac")
            echo "You chose Mac (mutt cmd)"
            echo "Mailing..."
            mutt -s "${subject}" -a ${proj_name}.zip -- $email < /dev/null
            echo "Sent."
            sh ../draper.sh
            ;;
        "Option 2: Linux")
            echo "You chose Linux (mail cmd)"
            echo "Mailing..."
            mail -s "${subject}" -a ${proj_name}.zip "${email}" < /dev/null
            echo "Sent."
            sh ../draper.sh
            ;;
        "Quit")
            break
            ;;
        *) echo "DO BETTER. Try again. $REPLY";;
    esac
done