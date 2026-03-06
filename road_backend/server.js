const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

const app = express();
app.use(cors());
app.use(express.json());

// ================= MONGODB CONNECT =================

// Replace with your MongoDB URL
mongoose.connect("Put your mongodb url here")
.then(() => console.log("MongoDB Connected"))
.catch(err => console.log(err));

// ================= SCHEMA =================

const detectionSchema = new mongoose.Schema({
  latitude: Number,
  longitude: Number,
  timestamp: String,
  prediction: String,
  confidence: Number
});

const Detection = mongoose.model("Detection", detectionSchema);

// ================= SAVE DATA =================

app.post("/api/detection", async (req, res) => {
  try {
    const newDetection = new Detection(req.body);
    await newDetection.save();
    res.json({ message: "Saved to MongoDB" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ================= DISPLAY TABLE =================

app.get("/", async (req, res) => {
  const detections = await Detection.find().sort({ _id: -1 });

  let rows = detections.map((d, index) => `
    <tr>
      <td>${index + 1}</td>
      <td>${d.latitude}</td>
      <td>${d.longitude}</td>
      <td>${d.timestamp}</td>
      <td>${d.prediction}</td>
      <td>${(d.confidence * 100).toFixed(2)}%</td>
    </tr>
  `).join("");

  res.send(`
    <html>
    <head>
      <title>AI Road Detections</title>
      <style>
        body { font-family: Arial; padding: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #333; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
      </style>
    </head>
    <body>
      <h2>AI Road Detection Log</h2>
      <table>
        <tr>
          <th>#</th>
          <th>Latitude</th>
          <th>Longitude</th>
          <th>Timestamp</th>
          <th>Prediction</th>
          <th>Confidence</th>
        </tr>
        ${rows}
      </table>
    </body>
    </html>
  `);
});


//for google maps api -
app.get("/map", async (req, res) => {
  const detections = await Detection.find();

  const filtered = detections.filter(d => d.confidence > 0.80);

  const markers = filtered.map(d => ({
    lat: d.latitude,
    lng: d.longitude,
    prediction: d.prediction,
    confidence: d.confidence
  }));

  res.send(`
  <html>
  <head>
    <title>AI Road Map</title>
    <style>
      #map { height: 100vh; width: 100%; }
    </style>
  </head>
  <body>
    <div id="map"></div>

    <script>
      const markers = ${JSON.stringify(markers)};

      function initMap() {
        const map = new google.maps.Map(document.getElementById("map"), {
          zoom: 14,
          center: markers.length > 0 ? markers[0] : {lat: 13.0827, lng: 80.2707}
        });

        markers.forEach(m => {
          let color;

          if (m.prediction === "pothole") color = "red";
          else if (m.prediction === "speedbreaker") color = "orange";
          else color = "green";

          new google.maps.Marker({
            position: { lat: m.lat, lng: m.lng },
            map: map,
            icon: {
              path: google.maps.SymbolPath.CIRCLE,
              scale: 8,
              fillColor: color,
              fillOpacity: 1,
              strokeWeight: 1
            },
            title: m.prediction + " (" + (m.confidence * 100).toFixed(1) + "%)"
          });
        });
      }
    </script>

    <script async
      src="put your google api key here">
    </script>
  </body>
  </html>
  `);
});

//for sending lat long to the main display and bot page -
app.get("/api/latest-location", async (req, res) => {

  const latest = await Detection.findOne().sort({ _id: -1 });

  if(!latest){
    return res.json({error:"No data"});
  }

  res.json({
    latitude: latest.latitude,
    longitude: latest.longitude,
    timestamp: latest.timestamp
  });

});

// ================= START SERVER =================

app.listen(5000, "0.0.0.0", () => {
  console.log("Server running on port 5000");
});