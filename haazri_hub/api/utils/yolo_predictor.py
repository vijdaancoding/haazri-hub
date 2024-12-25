import onnxruntime as ort
import numpy as np
import yaml
import cv2

config_path = "config.yaml"
onnx_model_path = 'best.onnx'

def preprocess(img):
    try:
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = cv2.resize(img, (640, 640), interpolation=cv2.INTER_LINEAR)
        img = img / 255.0
        img = img.transpose((2, 0, 1))
        img = img[np.newaxis, ...]
        return img.astype(np.float32)
    
    except Exception as e:
        raise RuntimeError(f"Image Preprocessing Failed: {e}")

def load_class_names(config_path):

    try:
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
        return config['names']
    
    except Exception as e:
        raise RuntimeError(f"Failed to Access classes_config.yaml: {e}")
    
def ObjectDetection(image_path):

    try:
        class_names = load_class_names(config_path)

        img = cv2.imread(image_path, cv2.IMREAD_COLOR)
        inputs = preprocess(img)

        sess = ort.InferenceSession(onnx_model_path)
        input_name = sess.get_inputs()[0].name
        output_name = sess.get_outputs()[0].name

        output = sess.run([output_name], {input_name: inputs})[0]

        pred = np.transpose(output[0], (1, 0))
        scores = np.max(pred[:, 4:], axis=1)
        clases = np.argmax(pred[:, 4:], axis=1)

        detected_classes = []
        conf_thres = 0.25
        for score, cls in zip(scores, clases):
            if score > conf_thres:
                class_name = class_names.get(int(cls), "Unknown")
                detected_classes.append(str(class_name))

        
        debug_var = list(set(detected_classes))

        print(debug_var)

        return debug_var
    
    except Exception as e:
        raise RuntimeError(f"Object Detection Failed: {e}")