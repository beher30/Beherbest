#!/bin/bash
set -ex

# Debug information
echo "=== Start Script ==="
echo "Current directory: $(pwd)"
echo "Python path: $(which python)"
echo "Pip version: $(pip --version)"

# Create and activate virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo -e "\n=== Creating virtual environment ==="
    python -m venv venv
fi

echo -e "\n=== Activating virtual environment ==="
source venv/bin/activate

# Upgrade pip and install requirements
echo -e "\n=== Installing dependencies ==="
python -m pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

# Set environment variables
export PYTHONPATH="$PWD:$PYTHONPATH"
export DJANGO_SETTINGS_MODULE="myproject.settings"
export PYTHONUNBUFFERED=1

# Show environment information
echo -e "\n=== Environment Information ==="
python --version
pip --version
which python
which pip
env | sort

# Verify Django installation
echo -e "\n=== Verifying Django installation ==="
python -c "import django; print(f'Django version: {django.__version__}')"

# Navigate to the project directory
echo -e "\n=== Current working directory: $(pwd) ==="
ls -la

# Run database migrations
echo -e "\n=== Running database migrations ==="
python manage.py migrate --noinput

# Create superuser if it doesn't exist (for development)
echo -e "\n=== Checking for superuser ==="
python -c "
import os, django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(is_superuser=True).exists():
    print('No superuser found. Creating one...')
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
    print('Superuser created successfully!')
else:
    print('Superuser already exists.')
"

# Collect static files
echo -e "\n=== Collecting static files ==="
python manage.py collectstatic --noinput --clear

# Start Gunicorn
echo -e "\n=== Starting Gunicorn ==="
exec gunicorn \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers 3 \
    --worker-class gthread \
    --threads 2 \
    --log-level=info \
    --log-file=- \
    --access-logfile=- \
    --error-logfile=- \
    --timeout 120 \
    --max-requests 5000 \
    --max-requests-jitter 500 \
    myproject.wsgi:application

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
