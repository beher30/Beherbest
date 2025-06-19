# Use the official Python 3.10 image with a specific tag
FROM python:3.10.12-slim-bullseye

# Set environment variables
ENV PYTHONDONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=myproject.settings \
    DEBUG=True

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install Django first explicitly
RUN pip install --no-cache-dir Django==4.2.0

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Set the correct working directory for the application
WORKDIR /app/Website/myproject

# Verify installation
RUN python -c "import django; print(f'Django version: {django.__version__}')" && \
    python -c "import sys; print('\n'.join(sys.path))" && \
    pip list

# Collect static files
RUN python manage.py collectstatic --noinput --clear

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "myproject.wsgi:application"]
