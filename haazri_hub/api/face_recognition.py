import cv2
from ultralytics import YOLO

def recognize_faces(image_path):
    model = YOLO('yolov8n.pt') 
    
    image = cv2.imread(image_path)
    
    results = model(image)

    faces = []
    for result in results.xyxy[0]:  # Results as [x_min, y_min, x_max, y_max, confidence, class]
        x_min, y_min, x_max, y_max, confidence, _class = result
        faces.append({
            "x_min": int(x_min),
            "y_min": int(y_min),
            "x_max": int(x_max),
            "y_max": int(y_max),
            "confidence": float(confidence)
        })

    return faces
