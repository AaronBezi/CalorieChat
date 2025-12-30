/**
 * CalorieChat API Proxy Server
 *
 * This server acts as a secure proxy between the Flutter client and the Gemini API.
 * It keeps the API key server-side, preventing exposure in client code.
 *
 * Setup:
 * 1. npm install express dotenv cors
 * 2. Create .env file with GEMINI_API_KEY=your_key
 * 3. node server.js
 */

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

/**
 * POST /api/parse-meal
 * Proxies meal parsing requests to Gemini API
 *
 * Request body:
 * {
 *   "text": "2 eggs and toast"
 * }
 *
 * Response:
 * {
 *   "items": [
 *     { "query": "eggs", "quantity": 2, "portionHint": null }
 *   ]
 * }
 */
app.post('/api/parse-meal', async (req, res) => {
  try {
    const { text } = req.body;

    // Validate input
    if (!text || typeof text !== 'string') {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Text field is required and must be a string'
      });
    }

    if (text.length < 3) {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Text must be at least 3 characters'
      });
    }

    if (text.length > 500) {
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Text must be less than 500 characters'
      });
    }

    // Check if API key is configured
    if (!process.env.GEMINI_API_KEY) {
      console.error('GEMINI_API_KEY not configured');
      return res.status(500).json({
        error: 'Configuration error',
        message: 'API key not configured on server'
      });
    }

    // Make request to Gemini API
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent`;

    const geminiResponse = await fetch(geminiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': process.env.GEMINI_API_KEY
      },
      body: JSON.stringify({
        contents: [{
          parts: [{
            text: `Parse the following meal description into structured food items.
Return ONLY valid JSON in this exact format (no markdown, no explanation):
{
  "items": [
    {
      "query": "food name",
      "quantity": 1,
      "portionHint": "optional portion description"
    }
  ]
}

Meal description: ${text}

Remember: Return ONLY the JSON object, nothing else.`
          }]
        }],
        generationConfig: {
          temperature: 0.1,
          maxOutputTokens: 1024
        }
      })
    });

    if (!geminiResponse.ok) {
      const errorText = await geminiResponse.text();
      console.error('Gemini API error:', geminiResponse.status, errorText);

      return res.status(geminiResponse.status).json({
        error: 'API error',
        message: 'Failed to process meal with AI',
        details: geminiResponse.status === 429 ? 'Rate limit exceeded' : 'API error'
      });
    }

    const geminiData = await geminiResponse.json();

    // Extract and clean the response
    let generatedText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!generatedText) {
      return res.status(500).json({
        error: 'Parse error',
        message: 'Invalid response from AI'
      });
    }

    // Clean up markdown code blocks if present
    generatedText = generatedText.trim();
    if (generatedText.startsWith('```json')) {
      generatedText = generatedText.substring(7);
    } else if (generatedText.startsWith('```')) {
      generatedText = generatedText.substring(3);
    }
    if (generatedText.endsWith('```')) {
      generatedText = generatedText.substring(0, generatedText.length - 3);
    }
    generatedText = generatedText.trim();

    // Parse the JSON
    const parsedData = JSON.parse(generatedText);

    // Validate response structure
    if (!parsedData.items || !Array.isArray(parsedData.items)) {
      return res.status(500).json({
        error: 'Parse error',
        message: 'Invalid response format from AI'
      });
    }

    // Return the parsed meal data
    res.json(parsedData);

  } catch (error) {
    console.error('Error in /api/parse-meal:', error);

    if (error instanceof SyntaxError) {
      return res.status(500).json({
        error: 'Parse error',
        message: 'Failed to parse AI response'
      });
    }

    res.status(500).json({
      error: 'Server error',
      message: 'An unexpected error occurred'
    });
  }
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not found',
    message: `Route ${req.method} ${req.path} not found`
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    error: 'Internal server error',
    message: 'An unexpected error occurred'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`CalorieChat API Proxy Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`API endpoint: http://localhost:${PORT}/api/parse-meal`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
