import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AutoCapturePage(),
    );
  }
}

class AutoCapturePage extends StatefulWidget {
  const AutoCapturePage({super.key});

  @override
  State<AutoCapturePage> createState() => _AutoCapturePageState();
}

class _AutoCapturePageState extends State<AutoCapturePage> {
  CameraController? _controller;
  Interpreter? _interpreter;
  Timer? _timer;

  bool isCapturing = false;
  int imageCount = 0;

  String lastPrediction = "None";
  double lastConfidence = 0.0;

  final List<String> labels = ["normal", "pothole", "speedbreaker"];

  double? latitude;
  double? longitude;
  DateTime? lastTimestamp;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel();
  }

  // ================= CAMERA =================

  Future<void> initializeCamera() async {
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  // ================= MODEL =================

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/road_condition_model_flex.tflite',
      options: InterpreterOptions()..threads = 4,
    );

    print("Model Loaded Successfully");
  }

  // ================= LOCATION =================

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ================= START CAPTURE =================

  Future<void> startCapturing() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_interpreter == null) {
      print("Model not loaded yet");
      return;
    }

    setState(() => isCapturing = true);

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = join(
          dir.path,
          'road_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        XFile file = await _controller!.takePicture();
        await file.saveTo(filePath);

        imageCount++;

        await runModelOnImage(filePath);

        setState(() {});
        print("Captured: $filePath");
      } catch (e) {
        print("Capture error: $e");
      }
    });
  }

  // ================= SEND TO SERVER ================= -->
  Future<void> sendToServer() async {
  if (latitude == null || longitude == null) return;

  final url = Uri.parse("http://put you device IP here/api/detection");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": lastTimestamp.toString(),
      "prediction": lastPrediction,
      "confidence": lastConfidence,
    }),
  );

  print("Server Response: ${response.statusCode}");
}

  void stopCapturing() {
    _timer?.cancel();
    setState(() => isCapturing = false);
  }

  // ================= INFERENCE =================

  Future<void> runModelOnImage(String imagePath) async {
    if (_interpreter == null) return;

    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();

    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) return;

    img.Image resizedImage =
        img.copyResize(originalImage, width: 224, height: 224);

    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    var output = List.generate(1, (i) => List.filled(3, 0.0));

    _interpreter!.run(input, output);

    int predictedIndex = output[0].indexOf(output[0].reduce(max));

    // Get GPS + Timestamp
    try {
      Position position = await _getCurrentLocation();
      latitude = position.latitude;
      longitude = position.longitude;
      lastTimestamp = DateTime.now();
    } catch (e) {
      print("Location error: $e");
    }

    setState(() {
      lastPrediction = labels[predictedIndex];
      lastConfidence = output[0][predictedIndex];
    });

    print("Prediction: $lastPrediction");
    print("Confidence: $lastConfidence");
    print("Lat: $latitude, Lng: $longitude");
    print("Time: $lastTimestamp");
    await sendToServer();
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("AI Road Detector")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
            const SizedBox(height: 10),
            Text("Images captured: $imageCount"),
            const SizedBox(height: 10),
            Text(
              "Prediction: $lastPrediction",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Confidence: ${(lastConfidence * 100).toStringAsFixed(2)} %",
            ),
            const SizedBox(height: 10),
            Text("Latitude: ${latitude ?? "N/A"}"),
            Text("Longitude: ${longitude ?? "N/A"}"),
            Text("Time: ${lastTimestamp ?? "N/A"}"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isCapturing ? null : startCapturing,
                  child: const Text("Start"),
                ),
                ElevatedButton(
                  onPressed: isCapturing ? stopCapturing : null,
                  child: const Text("Stop"),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}