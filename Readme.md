# 🚗 AI Road Condition Detection & SOS Alert System

Sample image for dashboard - <img width="1919" height="726" alt="image" src="https://github.com/user-attachments/assets/187aa76b-39dd-4914-b4b8-8c2d36bc93ca" />
Sample image for maps - 
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/3d0c0d60-2db5-4478-ad9b-fa90c8e3a4d6" />

An intelligent road monitoring system that uses **AI, computer vision, and GPS** to detect road anomalies such as **potholes and speed breakers** while automatically logging their locations to a backend server. The system also includes an **SOS emergency alert feature** that sends notifications to a **Telegram bot** with the vehicle’s location.

---

# 📌 Project Overview

This project combines **Flutter (mobile app)**, **TensorFlow Lite (AI model)**, and a **Node.js + MongoDB backend** to create a real-time road monitoring platform.

The mobile application continuously captures images from the camera, runs an AI model to detect road conditions, and sends the results along with GPS coordinates to a backend server. The backend stores detections in a database and visualizes them through a web interface and Google Maps.

Additionally, an **SOS emergency button** allows users to send their location instantly to the backend and receive an alert via **Telegram bot notification**.

---

# ⚙️ System Architecture

Flutter Mobile App
⬇
Camera + TensorFlow Lite Model
⬇
GPS Location (Geolocator)
⬇
Node.js Backend API
⬇
MongoDB Database
⬇
Web Dashboard + Google Maps Visualization
⬇
Telegram Bot Alerts (SOS)

---

# 🚀 Features

### 📷 AI Road Detection

* Detects **Normal Road**
* Detects **Potholes**
* Detects **Speed Breakers**
* Uses **TensorFlow Lite model**

### 📍 GPS Tracking

* Captures **latitude, longitude, and timestamp**
* Sent to backend with every detection

### 🗄 Backend Logging

* Stores detections in **MongoDB**
* Displays data in **web table dashboard**

### 🗺 Map Visualization

* Google Maps page displaying detected road anomalies
* Color coded markers:

  * 🔴 Red → Pothole
  * 🟠 Orange → Speed Breaker
  * 🟢 Green → Normal

### 🚨 SOS Emergency Alert

* Emergency button inside Flutter app
* Sends real-time GPS location to backend
* Backend sends alert to **Telegram Bot**

Example Telegram alert:

🚨 SOS ALERT
Vehicle TN07-XYX-123 has sent an emergency alert

Latitude: 13.0827
Longitude: 80.2707

Google Maps:
https://maps.google.com/?q=13.0827,80.2707

---

# 🧠 Technologies Used

### Mobile App

* Flutter
* Dart
* Camera Plugin
* Geolocator
* TensorFlow Lite
* HTTP package

### AI Model

* TensorFlow
* TensorFlow Lite

### Backend

* Node.js
* Express.js
* MongoDB
* Mongoose
* Axios

### Visualization

* HTML / CSS
* Google Maps JavaScript API

### Alerts

* Telegram Bot API

---

# 📂 Project Structure

```
road_detector_project
│
├── flutter_app
│   ├── main.dart
│   ├── model.tflite
│   └── assets
│
├── road_backend
│   ├── server.js
│   ├── package.json
│
└── README.md
```

---

# 🛠 Installation

## 1️⃣ Clone Repository

```
git clone https://github.com/yourusername/road-detector-ai.git
```

---

# 📱 Flutter App Setup

Install dependencies

```
flutter pub get
```

Run the app

```
flutter run
```

Required permissions:

AndroidManifest.xml

```
Camera
Location
Internet
```

---

# 🌐 Backend Setup

Navigate to backend folder

```
cd road_backend
```

Install dependencies

```
npm install
```

Run server

```
node server.js
```

Server runs on:

```
http://localhost:5000
```

---

# 🗄 MongoDB Setup

Create a **MongoDB Atlas cluster** and replace the connection string inside:

```
server.js
```

Example:

```
mongoose.connect("your_mongodb_connection_url")
```

---

# 🤖 Telegram Bot Setup

1️⃣ Open Telegram
2️⃣ Search **@BotFather**
3️⃣ Create a bot using

```
/newbot
```

4️⃣ Copy the bot token.

Example:

```
123456789:ABCDEF
```

---

### Get Chat ID

Open browser:

```
https://api.telegram.org/bot<TOKEN>/getUpdates
```

Send a message to your bot first.

Example response:

```
"chat": {
"id": 7474363345
}
```

Use this ID in `server.js`.

---

# 🌍 Web Dashboard

Open browser:

```
http://localhost:5000
```

Displays:

* Detection table
* Road condition logs

---

# 🗺 Google Maps View

```
http://localhost:5000/map
```

Displays detected road issues on a map.

---

# 📡 API Endpoints

### Save AI Detection

```
POST /api/detection
```

Body

```
{
 latitude,
 longitude,
 timestamp,
 prediction,
 confidence
}
```

---

### Send SOS Alert

```
POST /api/sos
```

Body

```
{
 latitude,
 longitude,
 timestamp
}
```

---

# 🧪 Example Workflow

1️⃣ App captures road image
2️⃣ AI model predicts road condition
3️⃣ GPS location captured
4️⃣ Data sent to backend
5️⃣ Backend logs detection
6️⃣ Map updated with marker

If **SOS button pressed**

7️⃣ Backend receives SOS
8️⃣ Telegram bot sends emergency alert

---

# 📈 Future Improvements

* Automatic **accident detection using phone accelerometer**
* Real-time **vehicle speed detection**
* Edge AI optimization
* Road quality analytics dashboard
* Integration with **smart city infrastructure**

---

# 👨‍💻 Author

Suriyan L

---

# 📜 License

This project is for **research and educational purposes**.



<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/955da113-de75-4f42-a233-ab7815c767a1" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/9d0d265f-65b1-4090-a2a9-29a45fcab890" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/4d4d239a-eae2-476e-a513-15ce3c2a3ae0" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/986c7c6b-0266-4561-8805-cfc100756c84" />
