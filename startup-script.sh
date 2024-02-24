#!/bin/bash


check_command() {
    if ! $1; then
        echo "Failed to execute: $1"
        # Handle the error, e.g., exit or perform some other action
    else
        echo "Successfully executed: $1"
    fi
}

# Attempt to run 'nvcc --version'
check_command "nvcc --version"

# Attempt to run 'nvidia-smi' to print out CUDA version
check_command "nvidia-smi"

# Cloning the repository as it's the first run
echo "Cloning the repository from https://github.com/clovaai/donut.git"
git clone https://github.com/clovaai/donut.git

# Check if git clone was successful
if [ $? -eq 0 ]; then
    echo "Repository cloned successfully."

    # Install requirements from requirements.txt
    echo "Installing dependencies from requirements.txt..."
    # Install specific versions of torch to ensure CUDA compatibility with AWS Instance
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    pip install --no-cache-dir -r ./requirements.txt
    pip install ipykernel && python -m ipykernel install --sys-prefix

    # Check if pip install was successful
    if [ $? -eq 0 ]; then
        echo "Dependencies installed successfully."
    else
        echo "Failed to install dependencies. Please check the requirements file and ensure pip is working."
    fi

else
    echo "Failed to clone repository. Please check if Git is installed and the URL is correct."
fi
echo "Final Contents: $(ls)"
