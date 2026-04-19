# ── Build stage ───────────────────────────────────────────────
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Pin to a known-good release for reproducible builds
ARG WHISPER_VERSION=v1.7.4
RUN git clone --depth 1 --branch ${WHISPER_VERSION} \
    https://github.com/ggerganov/whisper.cpp.git .

# Build server example (CPU-only, no CUDA/Metal)
RUN cmake -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DWHISPER_BUILD_EXAMPLES=ON \
      -DWHISPER_NO_AVX2=OFF \
    && cmake --build build --config Release -j$(nproc) --target whisper-server

# Download base.en model (~142 MB) — fast on CPU, good accuracy for short voice msgs
RUN bash ./models/download-ggml-model.sh base.en

# ── Runtime stage ─────────────────────────────────────────────
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /build/build/bin/whisper-server ./whisper-server
COPY --from=builder /build/models/ggml-base.en.bin  ./models/ggml-base.en.bin

ENV PORT=8778

EXPOSE ${PORT}

# -m  model path
# -t  threads (4 is safe for NAS CPU)
# --host / --port  bind address
CMD ["sh", "-c", \
     "./whisper-server -m ./models/ggml-base.en.bin -t 4 --host 0.0.0.0 --port ${PORT}"]
