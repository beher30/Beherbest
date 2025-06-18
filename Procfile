web: cd Website/myproject && \
  echo "Installing requirements..." && \
  pip install -r requirements.txt && \
  echo "Current directory: $(pwd)" && \
  echo "Python version: $(python --version)" && \
  echo "Pip version: $(pip --version)" && \
  echo "Installed packages:" && pip list && \
  echo "Starting Gunicorn..." && \
  python -m gunicorn myproject.wsgi:application --bind 0.0.0.0:$PORT --workers 4 --log-level=debug