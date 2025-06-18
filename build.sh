#!/usr/bin/env bash
# Exit on error and print commands as they are executed
set -ex

# Debug information
echo "=== Build script started ==="
echo "Current directory: $(pwd)"

# Upgrade pip and install Python build dependencies
echo "=== Upgrading pip and installing build dependencies ==="
python -m pip install --upgrade pip
pip install --upgrade setuptools wheel

# Install requirements from root requirements.txt
echo "=== Installing requirements ==="
echo "Installing from: $(pwd)/requirements.txt"
cat requirements.txt
pip install -r requirements.txt
echo "\n=== Installing Python dependencies ==="
pip install -r requirements.txt

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
