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

# Bump to bust GHA layer cache when cmake flags change
ARG CACHE_BUST=2

# Build server example (CPU-only, no CUDA/Metal)
# Target baseline x86-64 (SSE2 only) — NAS has Intel N3710 (Braswell), no AVX support
RUN cmake -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DWHISPER_BUILD_EXAMPLES=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DGGML_NATIVE=OFF \
      -DGGML_AVX=OFF \
      -DGGML_AVX2=OFF \
      -DGGML_FMA=OFF \
      -DGGML_F16C=OFF \
      "-DCMAKE_C_FLAGS=-mno-avx -mno-avx2 -mno-fma -mno-f16c" \
      "-DCMAKE_CXX_FLAGS=-mno-avx -mno-avx2 -mno-fma -mno-f16c" \
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
