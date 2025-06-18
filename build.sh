#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Python dependencies
pip install -r requirements.txt

# Navigate to the Django project directory
cd Website/myproject

# Collect static files
python manage.py collectstatic --no-input

# Apply migrations
python manage.py migrate
