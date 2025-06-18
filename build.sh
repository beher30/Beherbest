#!/usr/bin/env bash
# Exit on error and print commands as they are executed
set -ex

# Install Python dependencies
pip install --upgrade pip
pip install gunicorn
pip install -r requirements.txt

# Navigate to the Django project directory
cd Website/myproject

# Apply database migrations
echo "Applying migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "Build completed successfully!"
