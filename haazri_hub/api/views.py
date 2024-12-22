import logging
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from .serializers import UploadedImageSerializer
from .utils.yolo_predictor import ObjectDetection
from .services import UploadImageToFirebase
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from .models import RegisteredStudents, AttendanceRecord
from django.db import transaction
import os

logger = logging.getLogger(__name__)

class ObjectDetectionView(APIView):
    """
    OBJECT DETECTION VIEW -
    handles api for YOLO model
    """
    parser_classes = [MultiPartParser, FormParser]
    
    @csrf_exempt
    def post(self, request, *args, **kwargs):
        serializer = UploadedImageSerializer(data=request.data)
        if serializer.is_valid():
            uploaded_instance = serializer.save()
            image_path = uploaded_instance.image.path 

            print(f"Absolute Path to Image: {image_path}")  # Debugging

            try:
                with transaction.atomic():
                    detected_objects = ObjectDetection(image_path)
                    if not detected_objects: 
                        raise ValueError("No objects detected in image")

                    today = timezone.now().date()
                    processed_reg_nums = []
                    
                    for reg_num in detected_objects:
                        # Clean the reg_num string in case there are any suffixes
                        clean_reg_num = reg_num.strip().split()[0] if isinstance(reg_num, str) else str(reg_num)
                        
                        student = RegisteredStudents.objects.filter(reg_num=clean_reg_num).first()
                        if student:
                            AttendanceRecord.objects.update_or_create(
                                student=student,
                                date=today,
                                defaults={'is_present': True}
                            )
                            processed_reg_nums.append(clean_reg_num)
                        else:
                            logger.warning(f"Unregistered student detected: {clean_reg_num}")
                    
                    if not processed_reg_nums:
                        raise ValueError("No valid registered students found in detected objects")

                    # Prepare image upload data
                    today = timezone.now()
                    image_description = (f"Attendance taken on {today.date()}. "
                                      f"Raw detections: {detected_objects}, "
                                      f"Processed students: {', '.join(processed_reg_nums)}")

                    with open(image_path, 'rb') as image_file:
                        uploaded_instance.image.file.seek(0) 
                        result = UploadImageToFirebase(
                            uploaded_instance.image,  
                            description=image_description
                        )
                        logger.info(f"Successfully uploaded to Firebase: {result['firestore_id']}")

                return Response(status=status.HTTP_204_NO_CONTENT)

            except ValueError as ve:
                logger.error(f"Validation error: {str(ve)}")
                return Response(
                    {"error": str(ve)}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
            except Exception as e:
                logger.error(f"Error processing attendance: {str(e)}", exc_info=True)
                return Response(
                    {"error": "Internal server error occurred"}, 
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )
            finally:
                if os.path.exists(image_path):
                    try:
                        uploaded_instance.image.delete()
                        uploaded_instance.delete()
                    except Exception as e:
                        logger.error(f"Error cleaning up files: {str(e)}")

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

