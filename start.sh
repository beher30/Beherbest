#!/bin/bash
set -e  # Exit on error

# Debug information
echo "=== Starting deployment script ==="
echo "Current directory: $(pwd)"

# Navigate to the project root directory
cd "$(dirname "$0")"
echo "Changed to root directory: $(pwd)"

# Show Python and pip information
echo "\n=== Python Environment ==="
which python
python --version
which pip
pip --version

# Install requirements from root requirements.txt
echo "\n=== Installing requirements ==="
pip install --upgrade pip
echo "Installing from: $(pwd)/requirements.txt"
cat requirements.txt
pip install -r requirements.txt

# Navigate to the project directory
cd "Website/myproject"
echo "Changed to project directory: $(pwd)"

# Show installed packages
echo "\n=== Installed packages ==="
pip list

# Run migrations
echo "\n=== Running migrations ==="
python manage.py migrate --noinput

# Collect static files
echo "\n=== Collecting static files ==="
python manage.py collectstatic --noinput --clear

# Start Gunicorn
echo "\n=== Starting Gunicorn ==="
echo "Using PORT: $PORT"

# Ensure we have the correct Python path
export PYTHONPATH=$PYTHONPATH:$(pwd)

# Debug: Show Python path and Gunicorn location
echo "Python path: $PYTHONPATH"
which gunicorn || echo "Gunicorn not found in PATH"

# Start Gunicorn with the correct module path
exec gunicorn myproject.wsgi:application --bind 0.0.0.0:$PORT --workers 4 --log-level=debug --chdir .
