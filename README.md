# synology-whisper

Standalone HTTP transcription service running whisper.cpp on the Synology NAS. Accepts audio files (OGG, MP3, WAV) and returns transcribed text. Used by brian-telegram to transcribe Telegram voice messages before routing them to Claude.

## Features

- `POST /inference` — transcribe an audio file, returns JSON with the transcript
- `base.en` model baked into the Docker image — fast CPU inference, no GPU required
- No external API calls, no OpenAI account — fully self-hosted
- Built from whisper.cpp source in a multi-stage Docker image, published to GHCR

## Tech Stack

| Layer | Technology |
|---|---|
| Transcription | [whisper.cpp](https://github.com/ggerganov/whisper.cpp) |
| HTTP server | whisper.cpp built-in `server` example |
| Container | Docker (multi-stage build) |
| Registry | GitHub Container Registry (GHCR) |
| Host | Synology NAS |

## API

### `POST /inference`

Transcribe an audio file.

**Request:** `multipart/form-data`

| Field | Type | Description |
|---|---|---|
| `file` | audio file | OGG, WAV, MP3, or FLAC |
| `response_format` | string | `json` (default) or `text` |

**Response (JSON):**
```json
{ "text": "add eggs to the grocery list" }
```

**Example:**
```bash
curl -s -X POST http://localhost:8778/inference \
  -F "file=@voice.ogg" \
  -F "response_format=json"
```

## Getting Started

```bash
# Build locally
docker build -t synology-whisper .

# Run locally
docker run -p 8778:8778 synology-whisper

# Deploy to NAS via /synology skill
# (see ROADMAP.md)
```

## Deployment

Image is built and pushed to GHCR automatically on every push to `main` and weekly on Sundays. Deploy to the NAS using the `/synology` skill.

```
ghcr.io/aldarondo/synology-whisper:latest
```

## Project Status

Early development. See [ROADMAP.md](ROADMAP.md) for what's planned.

---
**Publisher:** Xity Software, LLC
