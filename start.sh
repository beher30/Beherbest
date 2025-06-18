#!/bin/bash

# Navigate to the project directory
cd "$(dirname "$0")/Website/myproject"

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt

# Show environment information
echo "Current directory: $(pwd)"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"
echo "Installed packages:"
pip list

# Run migrations
echo "Running migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

# Start Gunicorn
echo "Starting Gunicorn..."
exec python -m gunicorn myproject.wsgi:application --bind 0.0.0.0:$PORT --workers 4 --log-level=debug
