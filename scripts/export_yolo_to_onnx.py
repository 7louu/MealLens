import os
from ultralytics import YOLO

def main():
    # Define paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    assets_dir = os.path.join(project_root, 'app', 'assets', 'ai_models')
    model_path = os.path.join(assets_dir, 'yolo11n.pt')

    print(f"Loading YOLO11n model from: {model_path}")
    model = YOLO(model_path)

    print("Exporting to ONNX format...")
    # Export to ONNX with simplification for better compatibility
    # This will automatically save to the same directory as the .pt file
    exported_path = model.export(format='onnx', simplify=True)
    
    print(f"\n Export completed successfully!")
    print(f" ONNX model saved to: {exported_path}")
    print(f"\nThe model is now ready to use in your Flutter app!")

if __name__ == "__main__":
    main()
