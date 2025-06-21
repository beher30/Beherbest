#!/bin/bash
# Exit on error
set -e

echo "=== Starting Build Process ==="

# Print Python version
python --version

# Upgrade pip and setuptools
python -m pip install --upgrade pip setuptools wheel

# Create a minimal requirements.txt if it doesn't exist
if [ ! -f requirements.txt ]; then
    echo "Creating minimal requirements.txt..."
    echo "-e ." > requirements.txt
fi

# Install dependencies from pyproject.toml
if [ -f pyproject.toml ]; then
    echo "Installing from pyproject.toml..."
    pip install -e .
else
    echo "pyproject.toml not found, using requirements.txt..."
    pip install -r requirements.txt
fi

# Install gunicorn explicitly
pip install gunicorn==21.2.0

# Install any additional requirements if they exist
if [ -f requirements.txt ]; then
    echo "Installing additional requirements..."
    pip install -r requirements.txt
fi

# Run database migrations
echo "Running migrations..."
python manage.py migrate

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "=== Build Process Complete ==="
pip list
