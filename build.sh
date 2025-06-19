#!/bin/bash
set -e

# Debug information
echo "=== Build Script ==="
echo "Current directory: $(pwd)"
echo "Python version: $(python --version 2>&1 || echo 'Python not found')"

# Create and activate virtual environment
echo -e "\n=== Setting up virtual environment ==="
python -m venv venv
source venv/bin/activate

# Upgrade pip and install dependencies
echo -e "\n=== Installing dependencies ==="
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

# Verify Django installation
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"

# Show installed packages
echo -e "\n=== Installed packages ==="
pip list

# Show directory structure
echo -e "\n=== Directory structure ==="
ls -la

# Show installed packages for debugging
echo -e "\n=== Installed packages ==="
pip list

# Navigate to the project directory
echo -e "\n=== Setting up Django project ==="
cd Website/myproject

# Run database migrations
echo -e "\n=== Running database migrations ==="
python manage.py migrate --noinput

# Collect static files
echo -e "\n=== Collecting static files ==="
python manage.py collectstatic --noinput --clear

echo -e "\n=== Build completed successfully! ==="
# Verify Django is installed
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"
