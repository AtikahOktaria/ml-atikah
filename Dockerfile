# Menggunakan image Python 3.10 slim
FROM python:3.10-slim

# Menentukan variabel lingkungan untuk mencegah buffering pada output log
ENV PYTHONUNBUFFERED True

# Set work directory di dalam container
ENV APP_HOME /app
WORKDIR $APP_HOME

# Update dan install alat build serta library pendukung untuk dependencies tertentu
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    libpq-dev \
    libatlas-base-dev \  # Ini penting untuk TensorFlow dan numpy
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy semua file aplikasi ke dalam container
COPY . ./

# Install dependencies dari requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose port untuk aplikasi
EXPOSE 8080

# Gunakan Gunicorn untuk menjalankan aplikasi
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]