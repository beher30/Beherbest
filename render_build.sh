#!/bin/bash
# Exit on error
set -e

# Print environment variables
echo "=== Environment Variables ==="
printenv
echo "============================"

# Install Python 3.10 if not already installed
if ! command -v python3.10 &> /dev/null; then
    apt-get update && apt-get install -y python3.10 python3.10-venv python3.10-dev
fi

# Create and activate virtual environment
python3.10 -m venv /opt/render/project/src/.venv
source /opt/render/project/src/.venv/bin/activate

# Ensure pip is up to date
python -m pip install --upgrade pip

# Install the package in development mode
pip install -e .

# Install any additional requirements if needed
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi

# Install gunicorn
pip install gunicorn

# Verify Django installation
python -c "import django; print(f'Django version: {django.__version__}')"

# List installed packages for debugging
pip list
