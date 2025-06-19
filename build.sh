#!/bin/bash
set -ex

# Debug information
echo "=== Build Script ==="
echo "Current directory: $(pwd)"

# Install Python 3.10
echo -e "\n=== Installing Python 3.10 ==="
sudo apt-get update
sudo apt-get install -y python3.10 python3.10-venv python3.10-dev

# Create virtual environment with Python 3.10
echo -e "\n=== Creating virtual environment ==="
/usr/bin/python3.10 -m venv venv
source venv/bin/activate

# Show Python version
echo -e "\n=== Python version ==="
python --version

# Upgrade pip and install wheel
echo -e "\n=== Upgrading pip and wheel ==="
pip install --upgrade pip setuptools wheel

# Install Django first
echo -e "\n=== Installing Django ==="
pip install Django==4.2.0

# Install other dependencies
echo -e "\n=== Installing requirements ==="
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

# Navigate to the project directory
echo -e "\n=== Setting up Django project ==="
cd Website/myproject

# Show current directory
echo -e "\n=== Current directory: $(pwd) ==="
ls -la

# Run database migrations
echo -e "\n=== Running database migrations ==="
python manage.py migrate --noinput

# Collect static files
echo -e "\n=== Collecting static files ==="
python manage.py collectstatic --noinput --clear

echo -e "\n=== Build completed successfully! ==="

# Final verification
echo -e "\n=== Final verification ==="
python -c "import django; print(f'Django version: {django.__version__}')"
pip list
