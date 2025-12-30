# CalorieChat API Proxy Server

This is a secure backend proxy server that handles Gemini API requests for the CalorieChat Flutter app. It keeps the API key server-side, preventing exposure in client code.

## Features

- 🔒 **Secure**: API key never exposed to client
- 🚀 **Fast**: Minimal overhead proxy
- ✅ **Validated**: Input validation and error handling
- 📝 **Logged**: Request logging for debugging
- 🌐 **CORS**: Cross-origin support for web clients

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

## Deployment

### Deploy to Render.com (Free)

1. Create account at [render.com](https://render.com)
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Name**: calorie-chat-api
   - **Environment**: Node
   - **Build Command**: `cd backend && npm install`
   - **Start Command**: `cd backend && npm start`
   - **Add Environment Variable**: `GEMINI_API_KEY` = your_key
5. Click "Create Web Service"

Your API will be available at: `https://calorie-chat-api.onrender.com`

### Deploy to Railway (Free)

1. Create account at [railway.app](https://railway.app)
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your repository
4. Add environment variable: `GEMINI_API_KEY`
5. Railway will auto-detect Node.js and deploy

### Deploy to Vercel (Serverless)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd backend
vercel

# Add environment variable in Vercel dashboard
# GEMINI_API_KEY = your_key
```

### Deploy to Heroku

```bash
# Install Heroku CLI
# https://devcenter.heroku.com/articles/heroku-cli

# Login
heroku login

# Create app
heroku create calorie-chat-api

# Set environment variable
heroku config:set GEMINI_API_KEY=your_key

# Deploy
git push heroku main
```

## Security Notes

- ✅ API key stored server-side only
- ✅ Input validation (3-500 characters)
- ✅ Request size limits (10MB max)
- ✅ CORS enabled for your domain
- ⚠️ For production: Add rate limiting
- ⚠️ For production: Add authentication
- ⚠️ For production: Restrict CORS to your domain

## Production Recommendations

### Add Rate Limiting

```bash
npm install express-rate-limit
```

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

### Add Authentication (Optional)

```javascript
const API_SECRET = process.env.API_SECRET;

app.use('/api/', (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (authHeader !== `Bearer ${API_SECRET}`) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
});
```

### Restrict CORS

```javascript
const cors = require('cors');

app.use(cors({
  origin: 'https://your-app-domain.com'
}));
```

## Testing

```bash
# Health check
curl http://localhost:3000/health

# Parse meal
curl -X POST http://localhost:3000/api/parse-meal \
  -H "Content-Type: application/json" \
  -d '{"text":"2 eggs and toast"}'
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
