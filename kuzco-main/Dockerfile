FROM debian:stable-slim

# Install dependencies
RUN apt-get update && apt-get install -y curl systemd lsof procps git

# Set working directory
WORKDIR /app
RUN mkdir -p /app/cache

RUN git clone https://github.com/direkturcrypto/vikey-inference
RUN cd vikey-inference && echo '["llama3.2:3b-instruct-fp16"]' > models.json
COPY ./.env /app/.env
COPY ./vikey-inference-linux /app/vikey-inference-linux
COPY ./models.json /app/models.json

# Kembali ke working directory utama
WORKDIR /app

# Install Inference
RUN curl -fsSL https://devnet.inference.net/install.sh | sh

COPY ./start.sh /usr/local/bin/inference-runtime
COPY ./execute.sh /app/execute.sh
RUN chmod +x /app/execute.sh
RUN chmod +x /usr/local/bin/inference-runtime

# Jalankan Ollama Bridge dulu, lalu tunggu sampai siap sebelum Kuzco
CMD ["/app/execute.sh"]
