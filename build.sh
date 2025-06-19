#!/bin/bash
set -e

# Debug information
echo "=== Build Script ==="
echo "Current directory: $(pwd)"
echo "Python version: $(python3 --version 2>&1 || echo 'Python not found')"

# Ensure Python 3.10 is used
echo -e "\n=== Ensuring Python 3.10 is used ==="
sudo apt-get update
sudo apt-get install -y python3.10 python3.10-venv python3.10-dev

# Create and activate virtual environment
echo -e "\n=== Setting up virtual environment ==="
python3.10 -m venv venv
source venv/bin/activate

# Upgrade pip and install dependencies
echo -e "\n=== Installing dependencies ==="
pip install --upgrade pip setuptools wheel

# Install Django first
echo -e "\n=== Installing Django ==="
pip install Django==4.2.0

# Install other dependencies
pip install -r requirements.txt

# Verify Django installation
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"

# Show Python path
echo -e "\n=== Python path ==="
python -c "import sys; print('\n'.join(sys.path))"

# Show installed packages
echo -e "\n=== Installed packages ==="
pip list

# Show directory structure
echo -e "\n=== Directory structure ==="
ls -la

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
# Verify Django is installed again
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"

# Show final environment
echo -e "\n=== Final environment ==="
pip list"
