#!/usr/bin/env bash
# Exit on error and print commands as they are executed
set -ex

# Debug information
echo "=== Build script started ==="
echo "Current directory: $(pwd)"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"

# Create and activate virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "=== Creating virtual environment ==="
    python -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip and install Python build dependencies
echo "=== Upgrading pip and installing build dependencies ==="
python -m pip install --upgrade pip
pip install --upgrade setuptools wheel

# Install requirements from root requirements.txt
echo "=== Installing requirements ==="
echo "Installing from: $(pwd)/requirements.txt"
pip install -r requirements.txt

# Show installed packages for debugging
echo "\n=== Installed packages ==="
pip list

# Navigate to the project directory
echo "\n=== Setting up Django project ==="
cd Website/myproject

# Run database migrations
echo "\n=== Running database migrations ==="
python manage.py migrate --noinput

# Collect static files
echo "\n=== Collecting static files ==="
python manage.py collectstatic --noinput --clear

echo "Build completed successfully!"
