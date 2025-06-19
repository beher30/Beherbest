#!/bin/bash
set -e  # Exit on error

# Debug information
echo -e "\n=== Starting deployment script ==="
echo "Current directory: $(pwd)"

# Navigate to the project root directory
cd "$(dirname "$0")"
echo "Changed to root directory: $(pwd)"

# Ensure virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "\n=== Virtual environment not found, creating one ==="
    python -m venv venv
fi

# Activate the virtual environment
echo -e "\n=== Activating virtual environment ==="
source venv/bin/activate

# Ensure pip is up to date
echo -e "\n=== Ensuring pip is up to date ==="
python -m pip install --upgrade pip

# Install requirements if not already installed
echo -e "\n=== Checking Python dependencies ==="
if ! pip list | grep -q "Django"; then
    echo "Dependencies not found. Installing from requirements.txt..."
    pip install -r requirements.txt --no-cache-dir
    echo -e "\n=== Installed packages ==="
    pip list
else
    echo "Dependencies already installed."
fi

# Show Python and pip information
echo "\n=== Python Environment ==="
echo "Python path: $(which python)"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"

# Install requirements from root requirements.txt
echo "\n=== Installing requirements ==="
pip install --upgrade pip
pip install -r requirements.txt

# Show installed packages for debugging
echo "\n=== Installed packages ==="
pip list

# Navigate to the project directory
cd "Website/myproject"
echo "\n=== Changed to project directory: $(pwd) ==="

# Set Python path to include the project root
export PYTHONPATH=$PYTHONPATH:$(pwd)/..
echo "Python path set to: $PYTHONPATH"

# Show installed packages
echo "\n=== Installed packages ==="
pip list

# Run migrations
echo "\n=== Running migrations ==="
python manage.py migrate --noinput

# Collect static files
echo "\n=== Collecting static files ==="
python manage.py collectstatic --noinput --clear

# Start Gunicorn
echo "\n=== Starting Gunicorn ==="
echo "Using PORT: $PORT"

# Ensure we have the correct Python path
export PYTHONPATH=$PYTHONPATH:$(pwd)

# Debug: Show Python path and Gunicorn location
echo "Python path: $PYTHONPATH"
which gunicorn || echo "Gunicorn not found in PATH"

# Start Gunicorn with the correct module path
exec gunicorn myproject.wsgi:application --bind 0.0.0.0:$PORT --workers 4 --log-level=debug --chdir .
