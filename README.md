# 🍽️ MealLens

**MealLens** is a mobile application designed to help users track their **meal nutrients** in real-time using **computer vision** and **AI**. With a simple scan of your plate, the app identifies food items, estimates their **weight**, and calculates **calories**, **macronutrients**, and **micronutrients** — making healthy eating easier and smarter.

---

## 📱 Features

- 📸 **Real-time object detection** via camera with bounding boxes
- 🤖 **AI-powered food recognition** using Google Gemini 2.0 Flash
- 🔢 **Nutrient calculation** with detailed macros and micros
- 🔐 **Google Sign-In** with automatic profile creation
- ☁️ **Firebase integration** for user data and meal history
- 📊 **Clean UI** to track daily intake and insights

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** (SDK >=3.7.0) – Cross-platform mobile development
- **Dart** – Primary programming language
- **Camera Plugin** – Real-time camera access
- **Flutter Riverpod** – State management

### Backend
- **Firebase Authentication** – Google Sign-In
- **Cloud Firestore** – User profiles and meal history
- **Firebase Storage** – Image storage

### AI/ML
- **YOLO11n (ONNX)** – Real-time object detection
- **Google Gemini 2.0 Flash** – Food recognition and nutrient analysis
- **flutter_onnxruntime** – ONNX model inference on mobile
- **Python (Ultralytics)** – Model export and conversion

---

## 🧠 AI Implementation

### Hybrid AI Approach

MealLens uses a **hybrid AI architecture** combining on-device and cloud AI:

#### 1. **Real-Time Object Detection** (On-Device)
- **Model**: YOLO11n (Ultralytics)
- **Format**: ONNX (10.2 MB)
- **Input**: 640x640 RGB images
- **Output**: Bounding boxes with 80 COCO classes
- **Performance**: Processes every 10th frame to optimize memory
- **Purpose**: Provides visual feedback with bounding boxes on camera preview

#### 2. **Food Recognition & Analysis** (Cloud)
- **Model**: Google Gemini 2.0 Flash
- **Input**: Captured image from camera
- **Output**: Structured JSON with:
  - Food items identified
  - Estimated weight per item
  - Calories, macros (protein, carbs, fats)
  - Micronutrients (vitamins, minerals)
- **Advantages**: 
  - Superior accuracy for food recognition
  - No model size constraints
  - Automatic updates with model improvements
  - Free tier: 1,500 requests/day

### Model Export Process

The YOLO11n model is exported from PyTorch to ONNX format:

```python
from ultralytics import YOLO

# Load pretrained YOLO11n
model = YOLO('yolo11n.pt')

# Export to ONNX with simplification
model.export(format='onnx', simplify=True)
```

**Location**: `app/assets/ai_models/yolo11n.onnx`

---

## 📂 Project Structure

```
MealLens/
├── app/                          # Flutter application
│   ├── lib/
│   │   ├── models/              # Data models
│   │   ├── screens/             # UI screens
│   │   │   └── lensScreen.dart  # Camera + AI detection
│   │   ├── services/            # Business logic
│   │   │   ├── object_detection_service.dart  # YOLO inference
│   │   │   ├── food_recognition_service.dart  # Gemini API
│   │   │   └── auth_service.dart              # Firebase Auth
│   │   └── widgets/             # Reusable components
│   ├── assets/
│   │   └── ai_models/
│   │       ├── yolo11n.onnx     # Object detection model
│   │       └── labels.txt       # COCO class labels
│   └── android/                 # Android-specific config
├── scripts/                      # Python utilities
│   └── export_yolo_to_onnx.py   # Model export script
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >=3.7.0
- Android SDK (API 23+) or iOS 12+
- Firebase project with Authentication and Firestore enabled
- Google Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/MealLens.git
   cd MealLens/app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add `google-services.json` (Android) to `app/android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `app/ios/Runner/`

4. **Set up environment variables**
   Create `app/.env`:
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔧 Configuration

### Android Build Configuration

- **compileSdk**: 36
- **minSdk**: 23
- **targetSdk**: 36
- **Gradle**: 8.7
- **Android Gradle Plugin**: 8.6.0

### Performance Optimizations

- **Frame skipping**: Processes every 10th camera frame
- **Resolution**: Medium camera preset (720p)
- **Memory management**: Automatic garbage collection for ONNX sessions

---

## 📝 API Keys & Security

- **Gemini API Key**: Stored in `.env` file (not committed to git)
- **Firebase**: Configured via `google-services.json` (not committed to git)
- **Git**: `.env` and Firebase config files are in `.gitignore`

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- **Ultralytics** for YOLO11n
- **Google** for Gemini 2.0 Flash API
- **Firebase** for backend infrastructure
- **Flutter** team for the amazing framework
