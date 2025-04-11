# Gunakan image dasar Ubuntu
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl nginx

# Set working directory
WORKDIR /app
RUN mkdir -p /app/cache

# COPY config nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Kembali ke working directory utama
WORKDIR /app

# Copy file manual seperti sebelumnya
RUN curl -fsSL https://inference.supply/install.sh | sh

# Jalankan Ollama Bridge dulu, lalu tunggu sampai siap sebelum Kuzco
CMD service nginx restart & \
sleep 5; kuzco worker start --worker $KUZCO_WORKER --code $KUZCO_CODE --cache-directory-override=/app/cache
