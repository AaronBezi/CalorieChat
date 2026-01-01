# CalorieChat

AI-powered calorie tracking app with natural language meal logging

CalorieChat is a modern Flutter application that uses Google's Gemini AI to parse meal descriptions and track calories using USDA nutrition data. Simply describe what you ate in plain English, and the AI automatically identifies foods, portions, and calculates total calories.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=node.js&logoColor=white)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

![CalorieChat Demo](demo.gif)

---

## Features

### **AI-Powered Meal Logging**
- **Natural Language Input**: Just type "2 eggs and toast" - AI does the rest
- **Smart Food Matching**: 100+ food synonyms for accurate recognition
- **Fallback Parser**: Works even without internet connection

### **Food Search**
- **Wildcard Search**: Use `*bread`, `app*`, or `*milk*` patterns
- **USDA Database**: 104+ common foods with accurate nutrition data
- **Instant Results**: Fast search with pagination (25 items/page)

### **Insights & Analytics**
- **Daily Summary**: Total calories, meal count, and items
- **Weekly Overview**: 7-day calorie trends with averages
- **Meal History**: Recent meals with expandable details

### **Meal Editing**
- **Edit Descriptions**: Update meal names
- **Adjust Quantities**: Change food item amounts
- **Auto-Recalculation**: Calories update automatically

### **Data Export**
- **CSV Export**: Detailed meals or daily summaries
- **Excel Compatible**: Open in Excel, Google Sheets
- **Timestamped Files**: Easy organization

### **Security**
- **Secure API Proxy**: API key stored server-side only
- **Input Validation**: 3-500 character limits
- **Error Handling**: Graceful degradation

### **Cross-Platform**
- **Web**: Progressive Web App
- **Windows**: Native desktop app
- **Android/iOS**: Mobile apps (coming soon)

---

## Tech Stack

### **Frontend (Flutter)**
| Technology | Purpose | Version |
|------------|---------|---------|
| **Flutter** | Cross-platform UI framework | SDK 3.10+ |
| **Dart** | Programming language | 3.10.4 |
| **Provider** | State management | 6.1.1 |
| **Freezed** | Immutable models & JSON serialization | 2.4.1 |
| **Dio** | HTTP client with retry logic | 5.4.0 |
| **sqflite** | SQLite database (mobile) | 2.3.0 |
| **shared_preferences** | Web storage persistence | 2.2.2 |
| **intl** | Date/time formatting | 0.19.0 |
| **logger** | Structured logging | 2.0.2 |
| **csv** | CSV file generation | 6.0.0 |

### **Backend (Node.js)**
| Technology | Purpose | Version |
|------------|---------|---------|
| **Node.js** | Runtime environment | 18.0+ |
| **Express** | Web server framework | 4.18.2 |
| **dotenv** | Environment configuration | 16.3.1 |
| **cors** | Cross-origin support | 2.8.5 |

### **AI & APIs**
| Service | Purpose |
|---------|---------|
| **Google Gemini 2.0 Flash** | Meal parsing AI |
| **USDA MyPyramid** | Nutrition database |

### **DevOps & Tools**
| Tool | Purpose |
|------|---------|
| **Git** | Version control |
| **GitHub** | Code hosting |
| **Flutter Test** | Unit testing (30 tests) |
| **Build Runner** | Code generation |

---

## Quick Start

### Prerequisites

- **Flutter SDK** 3.10.4 or higher ([Install](https://docs.flutter.dev/get-started/install))
- **Node.js** 18.0+ ([Install](https://nodejs.org/))
- **Git** ([Install](https://git-scm.com/))
- **Gemini API Key** ([Get Free Key](https://aistudio.google.com/app/apikey))

### Installation

#### 1. Clone Repository
```bash
git clone https://github.com/yourusername/CalorieChat.git
cd CalorieChat/calorie_chat
```

#### 2. Setup Backend (API Proxy)
```bash
cd backend
npm install

# Create .env file with your API key
echo "GEMINI_API_KEY=your_api_key_here" > .env
echo "PORT=3000" >> .env
echo "NODE_ENV=development" >> .env

# Start backend server
npm start
```

You should see:
```
CalorieChat API Proxy Server running on port 3000
Health check: http://localhost:3000/health
```

#### 3. Setup Flutter App (New Terminal)
```bash
cd ..  # Back to calorie_chat root

# Install dependencies
flutter pub get

# Generate model code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run -d chrome
# or
flutter run -d windows
```

---

## Usage

### Log a Meal
1. Go to **Chat** tab
2. Type meal description: `"2 eggs, toast, and coffee"`
3. Click **Parse Meal**
4. Review detected foods and quantities
5. Adjust if needed, then click **Save Meal**

### Search Foods
1. Go to **Search** tab
2. Enter food name or use wildcards: `*bread*`
3. Browse results with pagination

### View Insights
1. Go to **Insights** tab
2. See today's totals and weekly trends
3. View meal history
4. **Edit** or **Delete** meals
5. **Export** data to CSV

---

## Architecture

### Frontend Architecture
```
lib/
├── core/
│   ├── config/          # Environment & constants
│   ├── network/         # API client (backend proxy)
│   ├── services/        # Export service
│   └── utils/           # Logging, text normalization
├── data/
│   ├── local/           # SQLite & web storage DAOs
│   ├── models/          # Freezed data models
│   └── repository/      # Data access layer
└── features/
    ├── chat/            # AI meal logging
    ├── search/          # Food search
    └── insights/        # Analytics & history
```

### Backend Architecture
```
backend/
├── server.js           # Express API proxy
├── package.json        # Dependencies
└── .env               # Configuration (API key)
```

### Data Flow
```
User Input → Flutter UI → Backend Proxy → Gemini API
                ↓                              ↓
         SQLite/Web Storage ← Parse Results ←─┘
```

---

### Web
```bash
flutter build web
```
Output: `build/web/`

### Windows
```bash
flutter build windows
```
Output: `build/windows/runner/Release/`

### Android
```bash
flutter build apk
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Database Schema

### Foods Table
```sql
CREATE TABLE foods (
  id TEXT PRIMARY KEY,
  description TEXT NOT NULL,
  portion TEXT NOT NULL,
  calories INTEGER NOT NULL
);
CREATE INDEX idx_foods_description ON foods(description);
```

### Logged Meals Table
```sql
CREATE TABLE logged_meals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  description TEXT NOT NULL,
  total_calories INTEGER NOT NULL,
  timestamp INTEGER NOT NULL
);
```

### Logged Meal Items Table
```sql
CREATE TABLE logged_meal_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  meal_id INTEGER NOT NULL,
  food_id TEXT NOT NULL,
  food_description TEXT NOT NULL,
  portion TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  calories INTEGER NOT NULL,
  FOREIGN KEY (meal_id) REFERENCES logged_meals(id) ON DELETE CASCADE
);
```

---

## Configuration

### Flutter `.env`
```env
# Backend API URL
API_BASE_URL=http://localhost:3000
```

### Backend `.env`
```env
# Gemini API Key (required)
GEMINI_API_KEY=your_key_here

# Server Port (optional)
PORT=3000

# Environment
NODE_ENV=development
```

---
</div>
