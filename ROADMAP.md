# synology-whisper Roadmap
> Tag key: `[Code]` = Claude Code · `[Synology]` = /synology skill · `[Human]` = Charles must act

## 🔄 In Progress
- [ ] `[CI]` Dockerfile fix pushed — CI rebuilding image with `-DBUILD_SHARED_LIBS=OFF` to fix missing `libwhisper.so.1`; auto-deploys to NAS on success
- [ ] `[Synology]` Smoke test with a real voice message OGG file — pending CI rebuild

## 🔲 Backlog

## ✅ Completed
- [x] `[Code]` 2026-04-19 — Dockerfile: multi-stage whisper.cpp build + `base.en` model baked in, ffmpeg in runtime for audio conversion
- [x] `[Code]` 2026-04-19 — GHCR build workflow with layer caching (build is slow — cache saves ~10 min on rebuilds)
- [x] `[Code]` 2026-04-19 — docker-compose.yml: joins brian-mcp_default network so brian-telegram can reach service at http://synology-whisper:8778
- [x] `[Code]` 2026-04-19 — brian-telegram wired: voice messages transcribed via /inference, transcript routed to Claude

## ✅ Completed
<!-- dated entries go here -->

## 🚫 Blocked
<!-- log blockers here -->
