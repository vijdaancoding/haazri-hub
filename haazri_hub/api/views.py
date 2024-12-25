"""
Author: Hamza Amin
Date: 2024-11-27

"""

import logging
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from .serializers import UploadedImageSerializer
from .utils.yolo_predictor import ObjectDetection
from .services import UploadImageToFirebase
from django.views.decorators.csrf import csrf_exempt
from .models import RegisteredStudents, AttendanceRecord
from django.db import transaction
from rest_framework.decorators import api_view
import os
from datetime import datetime

logger = logging.getLogger(__name__)

class ObjectDetectionView(APIView):
    """
    OBJECT DETECTION VIEW -
    HANDLES API REQUESTS FOR OBJECT DETECTION
    """
    parser_classes = [MultiPartParser, FormParser]
    
    @csrf_exempt
    def post(self, request, *args, **kwargs):
        serializer = UploadedImageSerializer(data=request.data)
        if serializer.is_valid():
            uploaded_instance = serializer.save()
            image_path = uploaded_instance.image.path 

            print(f"Absolute Path to Image: {image_path}") 

            try:
                with transaction.atomic():
                    detected_objects = ObjectDetection(image_path)
                    if not detected_objects: 
                        raise ValueError("No objects detected in image")

                    # today = timezone.now().date()
                  
                    today = datetime.now().date()
                    print(f"Today's Date: {today}")
                                        
                    processed_reg_nums = []
                    
                    for reg_num in detected_objects:
                        clean_reg_num = reg_num.strip().split()[0] if isinstance(reg_num, str) else str(reg_num)
                        processed_reg_nums.append(clean_reg_num)

                    if not processed_reg_nums:
                        raise ValueError("No valid registered students found in detected objects")

                    # Get all registered students
                    all_students = RegisteredStudents.objects.all()
                    
                    # Get or create attendance records for all students
                    for student in all_students:
                        attendance_record, created = AttendanceRecord.objects.get_or_create(
                            student=student,
                            date=today,
                            defaults={'is_present': False}
                        )
                        
                        # If student is detected in current image, mark them present
                        if student.reg_num in processed_reg_nums:
                            attendance_record.is_present = True
                            attendance_record.save()
                        # If record already exists and student was present before, keep them present
                        elif not created and attendance_record.is_present:
                            continue
                        # If new record and student not detected, they remain absent (default)

                    # Rest of the code for image processing and Firebase upload
                    
                    
                    # today = timezone.now()
                    today = datetime.now()
                    
                    image_description = (f"Attendance taken on {today.date()}. "
                                      f"Raw detections: {detected_objects}, "
                                      f"Processed students: {', '.join(processed_reg_nums)}")

                    with open(image_path, 'rb') as image_file:
                        uploaded_instance.image.file.seek(0) 
                        result = UploadImageToFirebase(
                            uploaded_instance.image,  
                            description=image_description
                        )
                        print(f"Successfully uploaded to Firebase: {result['firestore_id']}")

                return Response(
                    {"message": "Image uploaded and attendance processed successfully"},
                    status=status.HTTP_200_OK
                )
                
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



@api_view(['GET'])
def get_attendance_by_date(request):
    try:
        # Get dates and prefetch related data to optimize queries
        dates = AttendanceRecord.objects.values_list('date', flat=True)\
            .distinct().order_by('-date')  # Added descending order for latest first
        
        students = RegisteredStudents.objects.all()
        attendance_data = {}
        
        # Bulk fetch attendance records for optimization
        all_records = AttendanceRecord.objects.filter(date__in=dates)\
            .select_related('student')
        
        for date in dates:
            date_str = date.strftime('%Y-%m-%d')
            attendance_data[date_str] = []
            
            date_records = {record.student_id: record.is_present 
                          for record in all_records if record.date == date}
            
            for student in students:
                attendance_data[date_str].append({
                    'reg_num': student.reg_num,
                    'name': student.name,
                    'status': 'P' if date_records.get(student.reg_num, False) else 'A'
                })
        
        return Response(attendance_data, status=status.HTTP_200_OK)
        
    except Exception as e:
        logger.error(f"Error fetching attendance data: {str(e)}")
        return Response(
            {"error": "Failed to fetch attendance data"}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
