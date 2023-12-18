export current_date=$(date +"%Y-%m-%d")
export current_time=$(date +"%H:%M:%S")

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
    echo "${proj_name}_${fuid}" > "work/${project_name}/pid.txt"
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

    echo "Running email crawler..."
    
    python3 ../proj/emailscraper/main.py ../work/${project_name}/clean_${project_name}_${fuid}.txt # FIX BY CHANGING PYTHON TO ACCEPT FILENAME AS ARGUMENT
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

    sh ./src/email_func.sh ${subject} ${email} ${proj_name}
}

