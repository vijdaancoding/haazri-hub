from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from ultralytics import YOLO
from PIL import Image
from .serializers import UploadedImageSerializer

# Load YOLO model globally to avoid reloading on every request
yolo_model = YOLO('best.pt')

class ObjectDetectionView(APIView):
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request, *args, **kwargs):
        serializer = UploadedImageSerializer(data=request.data)
        if serializer.is_valid():
            uploaded_instance = serializer.save()
            # Get the absolute path to the uploaded file
            image_path = uploaded_instance.image.path

            print(f"Absolute Path to Image: {image_path}")  # Debugging

            try:
                # Open the image
                image = Image.open(image_path)
                results = yolo_model(image)

                predictions = results[0].boxes.data.tolist()
                detected_objects = []
                for pred in predictions:
                    class_id = int(pred[5])
                    class_name = results[0].names[class_id]
                    detected_objects.append(class_name)

                detected_objects = list(set(detected_objects))  # Remove duplicates
                response_data = {"detected_objects": detected_objects}
                print("testing : ")
                print(response_data)  # Debugging
                return Response(response_data, status=status.HTTP_200_OK)

            except Exception as e:
                return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
