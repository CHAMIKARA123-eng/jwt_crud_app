# 🔐 Flutter JWT CRUD App

A simple Flutter app with user registration, login, and JWT-based authentication, connected to a Node.js + MySQL backend.

## 🚀 Features

- ✅ Register and login using username and password  
- 🔐 JWT token authentication  
- 👥 View, update, and delete users  
- 🌙 Light & dark theme support  
- 🧪 Emulator-ready app (API uses `http://10.0.2.2:3000`)

## 📂 How to Run This App

### 1. Clone this repo

      git clone <your_repo_url>
      cd jwt_crud_app

### 2. Start the backend server

- Make sure your Node.js backend (e.g., jwt-crud-api) is running:

      cd jwt-crud-api
      node server.js

It must run on http://10.0.2.2:3000.

### 3. Run the Flutter app

     flutter pub get
     flutter run

## ⚠️ Important Notes

- This app is configured to run only on an Android emulator using http://10.0.2.2 to connect to the backend.

- To run it on a real Android device:

  - Replace all http://10.0.2.2:3000 URLs in api_service.dart with your local IP (e.g., http://192.168.x.x:3000)
  - Ensure both the device and PC are on the same Wi-Fi
  - Allow Internet permissions in your device if required

  


