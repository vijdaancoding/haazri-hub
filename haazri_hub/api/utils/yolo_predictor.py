from ultralytics import YOLO
from PIL import Image

yolo_model = YOLO('best.pt')

def ObjectDetection(image_path):

    try:
        image = Image.open(image_path)
        results = yolo_model(image)

        predictions = results[0].boxes.data.tolist()
        detected_objects = []
        for pred in predictions:
            class_id = int(pred[5])
            class_name = results[0].names[class_id]
            detected_objects.append(class_name)
        
        return list(set(detected_objects)) #Remove duplicates


    except Exception as e:
        raise RuntimeError(f"Object Detection Failed: {e}")