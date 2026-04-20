# synology-whisper Roadmap
> Tag key: `[Code]` = Claude Code · `[Synology]` = /synology skill · `[Human]` = Charles must act

## 🔄 In Progress
<!-- nothing active -->

## 🔲 Backlog

## ✅ Completed
- [x] `[Synology]` 2026-04-20 — Container deployed to NAS and smoke tested; transcription confirmed working
- [x] `[Code]` 2026-04-20 — Fixed `libwhisper.so.1` missing from runtime stage (`-DBUILD_SHARED_LIBS=OFF`) and `Illegal instruction` crash on N3710 Braswell (no AVX; fixed with `-DGGML_NATIVE=OFF` + explicit `-mno-avx*` flags)
- [x] `[Code]` 2026-04-19 — Dockerfile: multi-stage whisper.cpp build + `base.en` model baked in, ffmpeg in runtime for audio conversion
- [x] `[Code]` 2026-04-19 — GHCR build workflow with layer caching (build is slow — cache saves ~10 min on rebuilds)
- [x] `[Code]` 2026-04-19 — docker-compose.yml: joins brian-mcp_default network so brian-telegram can reach service at http://synology-whisper:8778
- [x] `[Code]` 2026-04-19 — brian-telegram wired: voice messages transcribed via /inference, transcript routed to Claude

## ✅ Completed
<!-- dated entries go here -->

## 🚫 Blocked
<!-- log blockers here -->
