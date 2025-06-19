#!/usr/bin/env bash
# Exit on error and print commands as they are executed
set -ex

# Debug information
echo -e "\n=== Build script started ==="
echo "Current directory: $(pwd)"

# Set Python path explicitly
PYTHON_PATH="/opt/render/project/src/.venv/bin/python"
PIP_PATH="/opt/render/project/src/.venv/bin/pip"

echo "Using Python path: $PYTHON_PATH"

# Show versions
echo -e "\n=== Python Environment ==="
$PYTHON_PATH --version
$PIP_PATH --version

# Create and activate virtual environment
echo -e "\n=== Setting up virtual environment ==="
if [ ! -d "venv" ]; then
    echo -e "\n=== Creating virtual environment ==="
    $PYTHON_PATH -m venv venv
fi
echo -e "\n=== Activating virtual environment ==="
source venv/bin/activate

# Ensure pip is up to date
echo -e "\n=== Upgrading pip and setuptools ==="
python -m pip install --upgrade pip setuptools wheel

# Install the package in development mode
echo -e "\n=== Installing package in development mode ==="
pip install -e .

# Install Django first to ensure it's available
echo -e "\n=== Installing Django ==="
pip install Django==4.2.0

# Install requirements from setup.py
echo -e "\n=== Installing dependencies from setup.py ==="
pip install -r requirements.txt

# Verify installations
echo -e "\n=== Verifying installations ==="
python -c "import django; print(f'Django version: {django.__version__}')"
pip list

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
