# 🍽️ MealLens

**MealLens** is a mobile application designed to help users track their **meal nutrients** in real-time using **computer vision**. With a simple scan of your plate, the app identifies food items, estimates their **weight**, and calculates **calories**, **macronutrients**, and **micronutrients** — making healthy eating easier and smarter.

---

## 📱 Features

- 📸 **Real-time food recognition** via camera
- ⚖️ **Depth estimation** for accurate weight prediction
- 🔢 **Nutrient calculation** based on recognized food & portion size
- ☁️ **Firebase integration** for user data and meal history
- 📊 **Clean UI** to track daily intake and insights

---

## 🛠️ Tech Stack

- **Flutter** – Mobile app development  
- **Firebase** – Backend (Auth, Firestore, Storage)  
- **TensorFlow Lite / ONNX** – AI model inference  
- **Pre-trained CV models** – Food classification & depth estimation  
- **Python** – Model testing and pre-processing

---

## 🧠 AI Models Used

- 🔍 **Food Recognition Model**: Pre-trained model for classifying food types from images
- 🌊 **Depth Estimation Model**: Real-time model to estimate food portion sizes
- 📈 **Nutrient Calculator**: Uses recognized food type and estimated weight to calculate nutritional values based on a public nutrition database

---
