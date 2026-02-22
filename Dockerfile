FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    python3 python3-pip git wget libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip install --upgrade pip

# Instala dependências
COPY ComfyUI/requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt && \
    pip install --no-cache-dir --force-reinstall \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Copia código
COPY ComfyUI/ /app/

# Cria diretórios para volumes
RUN mkdir -p /app/models /app/output /app/input /app/custom_nodes

EXPOSE 8188
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]