# Use the official Python 3.10 image
FROM python:3.10.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBUG=True \
    PYTHONPATH=/app

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .

# Install Django first to ensure it's available
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir Django==4.2.0 && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Set the correct working directory for the application
WORKDIR /app/Website/myproject

# Verify Django installation
RUN python -c "import django; print(f'Django version: {django.__version__}')"

# Collect static files
RUN python manage.py collectstatic --noinput

# Run the application
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:$PORT"]
