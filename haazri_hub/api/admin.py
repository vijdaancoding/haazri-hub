from django.contrib import admin
from .models import AttendanceRecord

@admin.register(AttendanceRecord)
class AttendanceRecordAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'timestamp']  # Customize the admin panel display
