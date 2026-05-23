FROM python:3.11-slim

WORKDIR /app

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps (NO venv inside container — the container is the isolation)
COPY marisa_auth/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source (excluding venv)
COPY marisa_auth/ .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5001", "--workers", "2", "--timeout", "120", "app:app"]
