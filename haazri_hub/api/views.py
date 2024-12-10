from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import AttendanceRecord
from .serializers import AttendanceRecordSerializer

# Mark attendance
@api_view(['POST'])
def mark_attendance(request):
    serializer = AttendanceRecordSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# List all attendance records
@api_view(['GET'])
def list_attendance(request):
    records = AttendanceRecord.objects.all()
    serializer = AttendanceRecordSerializer(records, many=True)
    return Response(serializer.data)

# Get a single attendance record by ID
@api_view(['GET'])
def get_attendance(request, id):
    try:
        record = AttendanceRecord.objects.get(pk=id)
        serializer = AttendanceRecordSerializer(record)
        return Response(serializer.data)
    except AttendanceRecord.DoesNotExist:
        return Response({"error": "Record not found"}, status=status.HTTP_404_NOT_FOUND)
