# LexoKontraten API

Local Node.js, Express and TypeScript backend for the thesis MVP.

## Local commands

```powershell
npm.cmd install
npm.cmd run dev
npm.cmd test
npm.cmd run typecheck
npm.cmd run build
```

Copy `.env.example` to `.env` only when local Supabase credentials are available.

The backend requires separate Supabase credentials for two purposes:

- `SUPABASE_SECRET_KEY` is restricted to trusted server operations.
- `SUPABASE_PUBLISHABLE_KEY` creates request-scoped clients that forward the
  verified user access token and preserve Row Level Security.

Never expose the server secret to the frontend.

## Current API

```text
GET /api/health
GET /api/health/database
GET /api/auth/me
GET /api/contracts
POST /api/contracts
POST /api/contracts/:contractId/versions
POST /api/contracts/:contractId/versions/:versionId/extract
POST /api/contracts/:contractId/versions/:versionId/analyze
```

`GET /api/contracts` requires a valid Supabase access token in the Bearer
authorization scheme. It returns contract metadata only and applies the
authenticated user's RLS policies.

`POST /api/contracts` requires the same authentication and accepts a strict
JSON body with `title` and `contractType`. Supported contract types are
`employment`, `service`, and `lease`. The authenticated user becomes the
owner, while the database supplies the ID, draft status, and timestamps.

`POST /api/contracts/:contractId/versions` accepts exactly one private
multipart `file` after authentication and ownership verification. The backend
validates PDF, DOCX, or UTF-8 TXT files up to 20 MB, computes SHA-256, uploads
to the existing private `contract-files` bucket, creates a pending
`contract_versions` row, and marks the parent contract as uploaded.

`POST /api/contracts/:contractId/versions/:versionId/extract` accepts an empty
request after authentication. It verifies ownership and the stored TXT
metadata before trusted access, conditionally claims a pending or failed
version, downloads the private object in memory, verifies its size and
SHA-256, and stores normalized UTF-8 text. DOCX files additionally pass strict
ZIP structure, path, encryption, Content Types, decompression-ratio, entry,
and uncompressed-size validation before raw-text extraction with Mammoth.
The response contains status metadata only and never returns the extracted
contract text. PDF, OCR, and analysis are not part of this endpoint yet.

`POST /api/contracts/:contractId/versions/:versionId/analyze` requires a valid
Bearer access token and an empty JSON body. The owned contract version must
have completed text extraction. A successful request returns the completed
analysis using the same response contract for a new or idempotently reused
result. The result provides general information and is not legal advice.
AI-assisted Kosovo-law citations and RAG are not implemented yet.
