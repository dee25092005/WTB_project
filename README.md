# 🌍 WTB Project (Where To Be)

A full-stack application designed for solo travelers to track villages and locations. This repository contains both the Go (Golang) backend and the Flutter mobile application.

---

## 📁 Repository Structure

```plaintext
WTB_project/
├── backend_golang/    # Go Gin API (Serverless ready for Vercel/Render)
│   ├── api/           # Vercel serverless entry point
│   ├── cmd/           # Local server entry point
│   ├── internal/      # Database logic, Handlers, and Routes
│   └── ...
└── wtb_app/           # Flutter Mobile Application
    ├── lib/           # App screens and logic
    ├── assets/        # Images and icons
    └── ...
```

---

## 🚀 Getting Started

### 1. Backend Setup (Go)

Navigate to the backend folder:

```bash
cd backend_golang
```

**Environment Variables:**

Create a `.env` file in the `backend_golang` folder with the following:

```env
DATABASE_URL=postgres://user:password@host:port/dbname
PORT=8080
CLOUDINARY_CLOUD_NAME=your_name
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret
```

**Run Locally:**

```bash
go run cmd/server/main.go
```

---

### 2. Frontend Setup (Flutter)

Navigate to the app folder:

```bash
cd wtb_app
```

**Configure API URL:**

Open `lib/services/api_service.dart` (or your equivalent service file) and update the `baseUrl`:

- **Local Development:** `http://localhost:8080/api`
- **Production:** `https://wtb-server.onrender.com/api`

**Run the App:**

```bash
flutter pub get
flutter run
```

---

## 🛠 Tech Stack

| Layer      | Technology                                      |
|------------|-------------------------------------------------|
| Backend    | Go, Gin Framework, PostgreSQL (pgxpool), Cloudinary |
| Frontend   | Flutter, Dart, Flutter Map                      |


---

## 📝 Features

- **Village Tracking:** Create, Read, Update, and Delete (CRUD) village records.
- **XP System:** Earn points and level up based on villages visited.
- **Image Management:** Automatic image upload to Cloudinary with background cleanup on deletion.

---

