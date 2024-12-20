from django.shortcuts import render, redirect
from django.http import JsonResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from .serializers import UploadedImageSerializer
from .utils.yolo_predictor import ObjectDetection
from .forms import ImageUploadForm
from .services import upload_image_to_firebase

class ObjectDetectionView(APIView):
    """
    OBJECT DETECTION VIEW -
    handles api for YOLO model
    """
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request, *args, **kwargs):
        serializer = UploadedImageSerializer(data=request.data)
        if serializer.is_valid():
            uploaded_instance = serializer.save()
            image_path = uploaded_instance.image.path #Path to uplaod image

            print(f"Absolute Path to Image: {image_path}")  # Debugging

            try:
                detected_objects = ObjectDetection(image_path)
                response_data = {"detected_objects": detected_objects}
                print(f"---DEBUGGING---\n{response_data}\n-------\n")  # Debugging
                return Response(response_data, status=status.HTTP_200_OK)

            except Exception as e:
                return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def upload_image(request):
    if request.method == 'POST':
        form = ImageUploadForm(request.POST, request.FILES)
        if form.is_valid():
            image = request.FILES['image']
            description = form.cleaned_data.get('description', '')

            result = upload_image_to_firebase(image, description)

            return JsonResponse({
                'message': 'Image uploaded successfully!',
                'url': result['url'],
                'firestore_id': result['firestore_id'],
                'description': description
            })

        else:
            return JsonResponse({'error': 'Invalid form data'}, status=400)

    return JsonResponse({'error': 'Invalid request method'}, status=400)