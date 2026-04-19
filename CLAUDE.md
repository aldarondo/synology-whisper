# synology-whisper

## Project Purpose
Standalone HTTP transcription service (whisper.cpp) running in Docker on the Synology NAS, called by brian-telegram to convert Telegram voice messages to text before routing to Claude.

## Key Commands
```bash
docker build -t synology-whisper .          # build image
docker run -p 8778:8778 synology-whisper    # run locally
curl -s -X POST http://localhost:8778/inference \
  -F "file=@voice.ogg" -F "response_format=json"  # test transcription
```

## Testing Requirements (mandatory)
- Every feature or bug fix must include unit tests covering the core logic
- Every user-facing flow must have at least one integration test
- Tests live in `tests/unit/` and `tests/integration/`
- Run all tests before marking any task complete: `bash tests/run.sh`

## After Every Completed Task (mandatory)
- Move the task to ✅ Completed in ROADMAP.md with today's date
- Update README.md if any feature, command, setup step, or interface changed

## Git Rules
- Never create pull requests. Push directly to main.
- solo/auto-push OK

## Skills
Before implementing any custom solution, check available skills first — prefer `/skill-name` over writing new code. The full list is visible in the Claude Code session context.

@~/Documents/GitHub/CLAUDE.md
