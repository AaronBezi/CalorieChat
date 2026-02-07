# CalorieChat

AI-powered calorie tracking app with natural language meal logging.

Describe what you ate in plain English — the AI identifies foods, estimates portions, and calculates calories from USDA nutrition data.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=node.js&logoColor=white)](https://nodejs.org)
[![Gemini](https://img.shields.io/badge/Gemini_AI-4285F4?style=flat&logo=google&logoColor=white)](https://ai.google.dev/)

---

## Features

- **Natural Language Meal Logging** — Type "2 eggs and toast" and the AI parses it automatically
- **Smart Food Matching** — 100+ food synonyms and a 104-food USDA database
- **Insights & Analytics** — Daily summaries, 7-day trends, weekly averages
- **Meal Editing** — Update descriptions, adjust quantities, auto-recalculate calories
- **Food Search** — Wildcard patterns (`*bread*`, `app*`) with pagination
- **CSV Export** — Detailed meals or daily summaries, Excel/Google Sheets compatible
- **Cross-Platform** — Web (PWA), Windows desktop, Android/iOS (coming soon)
- **Secure** — API key stored server-side only, input validation, graceful error handling
- **Offline Fallback** — Local parser works when the backend is unavailable

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.10+ / Dart, Provider, Freezed, Dio, sqflite |
| **Backend** | Node.js 18+, Express |
| **AI** | Google Gemini 2.0 Flash |
| **Database** | SQLite (mobile/desktop), in-memory (web) |
| **Nutrition Data** | USDA MyPyramid (104+ foods) |

---

## Quick Start

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.10.4+
- [Node.js](https://nodejs.org/) 18.0+
- [Gemini API Key](https://aistudio.google.com/app/apikey) (free)

### 1. Clone the repo

```bash
git clone https://github.com/AaronBezi/CalorieChat.git
cd CalorieChat/calorie_chat
```

### 2. Start the backend

```bash
cd backend
npm install
```

Create `backend/.env`:

```env
GEMINI_API_KEY=your_api_key_here
PORT=3000
NODE_ENV=development
```

```bash
npm start
```

### 3. Run the Flutter app (new terminal)

```bash
cd CalorieChat/calorie_chat

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome        # web
# or
flutter run -d windows       # desktop
```

### Configuration

**Flutter** `calorie_chat/.env`:
```env
API_BASE_URL=http://localhost:3000
```

**Backend** `calorie_chat/backend/.env`:
```env
GEMINI_API_KEY=your_key_here
PORT=3000
NODE_ENV=development
```

---

## Usage

### Log a Meal
1. Open the **Chat** tab
2. Type a meal description: `"2 eggs, toast, and coffee"`
3. Click **Parse Meal**
4. Review detected foods and adjust quantities
5. Click **Save Meal**

### Search Foods
1. Open the **Search** tab
2. Type a food name or use wildcards: `*bread*`
3. Browse paginated results

### View Insights
1. Open the **Insights** tab
2. See today's totals and 7-day trends
3. Edit or delete meals
4. Export data to CSV

---

## Architecture

```
calorie_chat/
├── lib/
│   ├── core/               # Config, networking, services, utils
│   ├── data/               # DAOs, models (Freezed), repositories
│   └── features/
│       ├── chat/           # AI meal logging
│       ├── search/         # Food search
│       └── insights/       # Analytics & history
├── backend/
│   └── server.js           # Express API proxy → Gemini
├── assets/data/            # USDA food database (JSON)
├── data_pipeline/          # USDA CSV-to-JSON conversion tools
└── test/                   # Unit tests (30 tests)
```

### Data Flow

```
User Input → Flutter UI → Backend Proxy → Gemini AI
                 ↓                            ↓
          SQLite / Web Storage ← Parsed Results
```

---

## Building for Production

```bash
# Web
flutter build web              # → build/web/

# Windows
flutter build windows          # → build/windows/runner/Release/

# Android
flutter build apk             # → build/app/outputs/flutter-apk/
```

---

## Testing

```bash
flutter test
```

30 unit tests covering input validation, state management, food matching, search, pagination, and text normalization.

---

## API

### Health Check
```
GET /health
→ { "status": "ok", "timestamp": "...", "version": "1.0.0" }
```

### Parse Meal
```
POST /api/parse-meal
Content-Type: application/json

{ "text": "2 eggs and toast" }

→ {
    "items": [
      { "query": "eggs", "quantity": 2, "portionHint": null },
      { "query": "toast", "quantity": 1, "portionHint": null }
    ]
  }
```

---

## License

MIT
