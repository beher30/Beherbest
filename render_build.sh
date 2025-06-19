#!/bin/bash
# Exit on error
set -e

# Print environment variables
echo "=== Environment Variables ==="
printenv
echo "============================"

# Install Python 3.10
apt-get update && apt-get install -y python3.10 python3.10-venv python3.10-dev

# Create and activate virtual environment
python3.10 -m venv /opt/render/project/src/.venv
source /opt/render/project/src/.venv/bin/activate

# Upgrade pip and install dependencies
pip install --upgrade pip
pip install -e .

# Install gunicorn
pip install gunicorn

# Verify Django installation
python -c "import django; print(f'Django version: {django.__version__}')"

# List installed packages for debugging
pip list
