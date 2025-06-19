#!/usr/bin/env bash
# Exit on error and print commands as they are executed
set -ex

# Debug information
echo "=== Build script started ==="
echo "Current directory: $(pwd)"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"

# Create and activate virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "=== Creating virtual environment ==="
    python -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Ensure pip is up to date
echo "=== Upgrading pip ==="
python -m pip install --upgrade pip

# Install wheel and setuptools first
pip install --upgrade setuptools wheel

# Install requirements from root requirements.txt
echo "=== Installing requirements ==="
echo "Installing from: $(pwd)/requirements.txt"
pip install -r requirements.txt --no-cache-dir

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
