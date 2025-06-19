#!/bin/bash
set -ex

# Debug information
echo "=== Start Script ==="
echo "Current directory: $(pwd)"

# Navigate to the project root directory
cd "$(dirname "$0")"
echo "Changed to root directory: $(pwd)"

# Activate virtual environment
echo -e "\n=== Activating virtual environment ==="
source venv/bin/activate

# Show Python and environment information
echo "\n=== Python Environment ==="
echo "Python path: $(which python)"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"

# Show installed packages
echo "\n=== Installed packages ==="
pip list

# Verify Django installation
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"

# Navigate to the project directory
cd "Website/myproject"
echo "\n=== Changed to project directory: $(pwd) ==="

# Show final environment
echo "\n=== Final environment before starting Gunicorn ==="
python -c "import sys; print('\n'.join(sys.path))"
pip list

# Set PYTHONPATH to include the project root
export PYTHONPATH=$(pwd):$PYTHONPATH
echo "PYTHONPATH set to: $PYTHONPATH"

# Start Gunicorn
echo -e "\n=== Starting Gunicorn ==="
exec gunicorn --bind 0.0.0.0:$PORT myproject.wsgi:application

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
