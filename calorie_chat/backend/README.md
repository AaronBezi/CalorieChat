# CalorieChat API Proxy Server

This is a secure backend proxy server that handles Gemini API requests for the CalorieChat Flutter app. It keeps the API key server-side, preventing exposure in client code.

## Quick Start

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Configure Environment

```bash
# Copy example env file
cp .env.example .env

# Edit .env and add your Gemini API key
# GEMINI_API_KEY=your_actual_key_here
```

### 3. Run Server

```bash
# Production
npm start

# Development (with auto-reload)
npm run dev
```

Server will start on `http://localhost:3000`

## API Endpoints

### Health Check

```bash
GET /health
```

Response:
```json
{
  "status": "ok",
  "timestamp": "2025-12-29T10:00:00.000Z",
  "version": "1.0.0"
}
```

### Parse Meal

```bash
POST /api/parse-meal
Content-Type: application/json

{
  "text": "2 eggs and toast"
}
```

Response:
```json
{
  "items": [
    {
      "query": "eggs",
      "quantity": 2,
      "portionHint": null
    },
    {
      "query": "toast",
      "quantity": 1,
      "portionHint": null
    }
  ]
}
```

Error Response:
```json
{
  "error": "Invalid request",
  "message": "Text must be at least 3 characters"
}
```

## Logs

The server logs all requests:
```
2025-12-29T10:00:00.000Z - POST /api/parse-meal
2025-12-29T10:00:01.000Z - GET /health
```

## Troubleshooting

**"API key not configured"**
- Make sure `.env` file exists in `backend/` directory
- Check that `GEMINI_API_KEY` is set in `.env`

**CORS errors in browser**
- Make sure CORS is enabled in `server.js`
- Check browser console for specific error

**Port already in use**
- Change `PORT` in `.env` to a different number
- Or kill the process using port 3000

## License

MIT
