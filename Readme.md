# 🚗 AI Road Condition Detection & SOS Alert System
An intelligent road monitoring system that uses **AI, computer vision, and GPS** to detect road anomalies such as **potholes and speed breakers** while automatically logging their locations to a backend server. The system also includes an **SOS emergency alert feature** that sends notifications to a **Telegram bot** with the vehicle’s location.
Team - 11 - Suriyan Loganathan, Udhayadev G S, Dhakshnamoorthy J

Sample image for dashboard - <img width="1519" height="526" alt="image" src="https://github.com/user-attachments/assets/187aa76b-39dd-4914-b4b8-8c2d36bc93ca" />
<img width="1912" height="667" alt="image" src="https://github.com/user-attachments/assets/ab456f52-87cb-4de7-8f13-6870707086c3" />

Sample image for maps - 
<img width="1519" height="779" alt="image" src="https://github.com/user-attachments/assets/3d0c0d60-2db5-4478-ad9b-fa90c8e3a4d6" />
<img width="1080" height="617" alt="image" src="https://github.com/user-attachments/assets/201c245e-49ee-48e5-b19a-cd3eac97cf8b" />
Telegram in emergency contacts phone when there is an SOS alert - ![WhatsApp Image 2026-03-06 at 4 31 13 PM](https://github.com/user-attachments/assets/899ae387-4e61-4dd6-a1fb-99603723d23f)

---

# 📌 Project Overview

This project uses **Flutter, TensorFlow Lite, and a Node.js + MongoDB backend** to build a real-time road monitoring system. The mobile app captures images, detects road conditions using an AI model, and sends the results with GPS coordinates to the backend. The server stores detections and visualizes them on a **web dashboard and Google Maps**.

An **SOS emergency button** allows users to send their location instantly, triggering a **Telegram bot alert**.

---

# ⚙️ System Architecture

Flutter App
↓
Camera + TensorFlow Lite
↓
GPS Location (Geolocator)
↓
Node.js API
↓
MongoDB Database
↓
Web Dashboard + Google Maps
↓
Telegram SOS Alerts

---

# 🚀 Features

### 📷 AI Road Detection

* Detects **Normal Road**
* Detects **Potholes**
* Detects **Speed Breakers**
* Runs using **TensorFlow Lite**

### 📍 GPS Tracking

* Captures **latitude, longitude, timestamp**
* Sends location with every detection

### 🗄 Backend Logging

* Stores detections in **MongoDB**
* Displays logs in a **web dashboard**

### 🗺 Map Visualization

* Google Maps showing detected road issues
* Color markers:

  * 🔴 Pothole
  * 🟠 Speed Breaker
  * 🟢 Normal Road

### 🚨 SOS Emergency Alert

* SOS button in mobile app
* Sends GPS location to backend
* Backend triggers **Telegram bot notification**

Example alert:

🚨 SOS ALERT
Vehicle TN07-XYX-123 sent an emergency alert

Latitude: 13.0827
Longitude: 80.2707

https://maps.google.com/?q=13.0827,80.2707

---

# 🧠 Technologies Used

**Mobile App**

* Flutter
* Dart
* Camera
* Geolocator
* TensorFlow Lite

**Backend**

* Node.js
* Express
* MongoDB
* Mongoose
* Axios

**Visualization**

* HTML / CSS
* Google Maps API

**Alerts**

* Telegram Bot API

---

# 📂 Project Structure

```
road_detector_project
│
├── flutter_app
│   ├── main.dart
│   └── model.tflite
│
├── road_backend
│   ├── server.js
│   └── package.json
│
└── README.md
```

---

# 🛠 Installation

### Clone repository

```
git clone https://github.com/yourusername/road-detector-ai.git
```

### Flutter App

```
flutter pub get
flutter run
```

Required permissions:

* Camera
* Location
* Internet

### Backend

```
cd road_backend
npm install
node server.js
```

Server runs at:

```
http://localhost:5000
```

---

# 🌍 Web Dashboard

Detection logs:

```
http://localhost:5000
```

Map visualization:

```
http://localhost:5000/map
```

---

# 📡 API Endpoints

**Save Detection**

```
POST /api/detection
```

**Send SOS**

```
POST /api/sos
```

---

# 👨‍💻 Author

Suriyan L


<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/955da113-de75-4f42-a233-ab7815c767a1" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/9d0d265f-65b1-4090-a2a9-29a45fcab890" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/4d4d239a-eae2-476e-a513-15ce3c2a3ae0" />
<img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/986c7c6b-0266-4561-8805-cfc100756c84" />
