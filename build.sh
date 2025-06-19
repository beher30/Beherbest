#!/usr/bin/env bash
# Exit on error and print commands as they are executed
set -ex

# Debug information
echo -e "\n=== Build script started ==="
echo "Current directory: $(pwd)"

# Set Python path explicitly
PYTHON_PATH="/opt/render/project/src/.venv/bin/python"
echo "Using Python path: $PYTHON_PATH"

# Show versions
echo -e "\n=== Python Environment ==="
$PYTHON_PATH --version
$PYTHON_PATH -m pip --version

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo -e "\n=== Creating virtual environment ==="
    $PYTHON_PATH -m venv venv
fi

# Activate virtual environment
echo -e "\n=== Activating virtual environment ==="
source venv/bin/activate

# Ensure pip is up to date
echo -e "\n=== Upgrading pip ==="
python -m pip install --upgrade pip

# Install wheel and setuptools first
echo -e "\n=== Installing build dependencies ==="
pip install --upgrade setuptools wheel

# Install requirements
echo -e "\n=== Installing requirements ==="
echo "Installing from: $(pwd)/requirements.txt"
pip install -r requirements.txt --no-cache-dir

# Verify Django installation
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"

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
