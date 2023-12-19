#!/bin/bash

# Current date variable
export current_date=$(date +"%Y-%m-%d")
export current_time=$(date +"%H:%M:%S")
export fuid=${current_date}-${current_time}

# Generate a random number between 0000 and 9999 variable
export random_number=$(( RANDOM % 10000 ))
export rand_num=$(printf "%04d" $random_number)

# Function to create a new project directory in ./work
function cr_proj_dir() {
    # Check if a project name is provided
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <project_name>"
        exit 1
    fi

    # The project name is the first argument
    export project_name=$1

    # Create the project directory
    echo "Creating project directory"
    mkdir -p "work/${project_name}"

    # Create PID file
    echo "${project_name}_${fuid}" > "work/${project_name}/pid.txt"
    echo PID created:
    cat "work/${project_name}/pid.txt"
}

# Function to delete everything in ./work
function trunc_work() {
    # Delete everything in the work directory
    rm -rf work/*
}

# Function to run email crawler
function email_crawl() {
    # Check if a project name is provided
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <project_name>"
        exit 1
    fi

    export project_name=$1
    export pid=$(cat ./work/${project_name}/pid.txt)

    python3 ./proj/emailscraper/main.py ./work/${project_name}/clean_${project_name}_${pid}.txt # FIX BY CHANGING PYTHON TO ACCEPT FILENAME AS ARGUMENT
}

# Mail function
function mail_output() {
    # Check if a subject name is provided
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <subject> <email> <proj_name>"
        exit 1
    fi

    export subject=$1
    export email=$2
    export proj_name=$3

    sh "./src/email_func.sh" "${subject}" "${email}" "${proj_name}"
}

# Function to see if chromedriver exists in /usr/bin, if not, download it
function check_chromedriver() {
    if [[ "$(lsb_release -is 2>/dev/null)" == "Ubuntu" ]]; then
        # Check if chromedriver exists in /usr/bin
        if [[ -f "/usr/bin/chromedriver" ]]; then
            echo "System checks passed."
            # You can add more commands here
        else
            echo "Chromedriver does not exist in /usr/bin. Downloading..."
            if sudo apt update && sudo apt install -y chromedriver; then
                echo "Chromedriver installed successfully."
                # Create a symbolic link in /usr/bin if it's not already there
                local chromedriver_path=$(which chromedriver)
                if [[ -n "$chromedriver_path" && ! -f "/usr/bin/chromedriver" ]]; then
                    sudo ln -s "$chromedriver_path" /usr/bin/chromedriver
                    echo "Chromedriver symlink created in /usr/bin."
                fi
            else
                echo "Failed to install chromedriver."
                return 1  # Exit the function with an error status
            fi
        fi
    else
        echo "This script is intended for Ubuntu systems only."
        return 1  # Exit the function with an error status
    fi
}