# Gunakan image dasar Ubuntu
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl nodejs npm git

# Set working directory
WORKDIR /app
RUN mkdir -p /app/cache

# Clone Ollama Bridge dari GitHub
RUN git clone https://github.com/direkturcrypto/ollama-server-bridging.git

# Masuk ke Ollama Bridge dan install dependensinya
WORKDIR /app/ollama-server-bridging
RUN npm install

# Kembali ke working directory utama
WORKDIR /app

# Copy file manual seperti sebelumnya
RUN curl -fsSL https://inference.supply/install.sh | sh

# Port expose
EXPOSE 14444

# Jalankan Ollama Bridge dulu, lalu tunggu sampai siap sebelum Kuzco
CMD npm --prefix /app/ollama-server-bridging start & \
kuzco worker start --worker $KUZCO_WORKER --code $KUZCO_CODE --cache-directory-override=/app/cache
