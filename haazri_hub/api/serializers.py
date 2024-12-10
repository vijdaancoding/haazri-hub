from rest_framework import serializers
from .models import AttendanceRecord

class AttendanceRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = AttendanceRecord
        fields = '__all__'
