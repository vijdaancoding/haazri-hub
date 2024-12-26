"""
Author: Hamza Amin
Date: 2024-11-27

"""

import os
import logging
from typing import List
import cv2 as cv
import numpy as np
from keras_facenet import FaceNet
from mtcnn import MTCNN
from sklearn.preprocessing import LabelEncoder
import pickle
from functools import lru_cache

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class FaceDetectionModel:
    """Face detection and recognition model using FaceNet and MTCNN."""

    _instance = None  # Singleton instance

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(FaceDetectionModel, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        if self._initialized:
            return

        try:
            logger.info("Initializing face detection model...")
            self.facenet = FaceNet()
            self.detector = MTCNN()

            # Load model files
            self._load_model_files()

            self._initialized = True
            logger.info("Model initialization completed successfully")
        except Exception as e:
            logger.error(f"Failed to initialize model: {str(e)}")
            raise RuntimeError("Model initialization failed")

    @lru_cache(maxsize=1)
    def _load_model_files(self) -> None:
        """Load model files with caching."""
        try:
            model_path = "svm_model_160x160.pkl"
            embeddings_path = "class_embeddings.npz"

            if not all(os.path.exists(path) for path in [model_path, embeddings_path]):
                raise FileNotFoundError("Required model files not found")

            self.faces_embeddings = np.load(embeddings_path)
            self.Y = self.faces_embeddings["arr_1"]
            self.encoder = LabelEncoder()
            self.encoder.fit(self.Y)

            with open(model_path, "rb") as f:
                self.model = pickle.load(f)

        except Exception as e:
            logger.error(f"Error loading model files: {str(e)}")
            raise

    def _validate_image(self, image_path: str) -> None:
        """Validate image file existence and format."""
        if not os.path.exists(image_path):
            raise FileNotFoundError(f"Image not found: {image_path}")

        valid_extensions = {".jpg", ".jpeg", ".png", ".bmp"}
        if not os.path.splitext(image_path)[1].lower() in valid_extensions:
            raise ValueError("Unsupported image format")

    def _preprocess_face(self, face: np.ndarray) -> np.ndarray:
        """Preprocess detected face for model input."""
        try:
            face = cv.resize(face, (160, 160))
            return np.expand_dims(face, axis=0)
        except Exception as e:
            logger.error(f"Face preprocessing failed: {str(e)}")
            raise

    def detect_faces(self, image_path: str, debug: bool = False) -> List[str]:
        """
        Detect and recognize faces in the given image.

        Args:
            image_path: Path to the input image
            debug: Enable debug output

        Returns:
            List of detected face labels
        """
        try:
            self._validate_image(image_path)

            img = cv.imread(image_path)
            if img is None:
                raise ValueError("Failed to load image")

            rgb_img = cv.cvtColor(img, cv.COLOR_BGR2RGB)
            results = self.detector.detect_faces(rgb_img)

            if debug:
                logger.info(f"Detected {len(results)} faces in image")

            labels = []
            for idx, result in enumerate(results):
                x, y, w, h = result["box"]
                x, y = abs(x), abs(y)

                face = rgb_img[y : y + h, x : x + w]
                processed_face = self._preprocess_face(face)

                # Get embeddings and predict
                embedding = self.facenet.embeddings(processed_face)
                prediction = self.model.predict(embedding)
                final_name = self.encoder.inverse_transform(prediction)[0]

                if debug:
                    confidence = result["confidence"]
                    logger.info(
                        f"Face {idx+1}: Label={final_name}, Confidence={confidence:.2f}"
                    )

                labels.append(final_name)
            print(f"Printing detecting students : {labels}")
            return labels

        except Exception as e:
            logger.error(f"Face detection failed: {str(e)}")
            raise


# Global instance for the facade pattern
_model_instance = None


def ObjectDetection(image_path: str) -> List[str]:
    """
    Facade function for backward compatibility with existing code.
    Detects and recognizes faces in the given image.

    Args:
        image_path: Path to the input image

    Returns:
        List[str]: List of detected face labels

    Raises:
        Exception: If face detection fails
    """
    global _model_instance

    try:
        # Lazy initialization of the model
        if _model_instance is None:
            _model_instance = FaceDetectionModel()

        # Use the class implementation but handle errors gracefully
        return _model_instance.detect_faces(image_path, debug=False)

    except Exception as e:
        logger.error(f"Error in ObjectDetection: {str(e)}")
        # Return empty list instead of raising exception for backward compatibility
        return []
