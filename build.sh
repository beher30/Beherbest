#!/bin/bash

# Render Build Script for BeHerBest Django Application

echo "Starting build process..."

# Update pip
echo "Updating pip..."
python -m pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Navigate to Django project directory
echo "Navigating to Django project directory..."
cd Website/myproject

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

# Run database migrations
echo "Running database migrations..."
python manage.py migrate

echo "Build completed successfully!"
