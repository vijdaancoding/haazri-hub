from django.contrib import admin
from .models import UploadedImage, RegisteredStudents, AttendanceRecord, StoredImages

@admin.register(UploadedImage)
class UploadedImageAdmin(admin.ModelAdmin):
    list_display = ('id', 'image', 'uploaded_at')
    list_filter = ('uploaded_at',)
    search_fields = ('id',)

@admin.register(RegisteredStudents)
class RegsiteredStudentsAdmin(admin.ModelAdmin):
    list_display = ('reg_num', 'name')
    search_fields = ('reg_num', 'name')

@admin.register(AttendanceRecord)
class AttendanceRecordAdmin(admin.ModelAdmin):
    list_display = ('student', 'date', 'is_present')
    list_filter = ('is_present', 'date')

@admin.register(StoredImages)
class StoredImagesAdmin(admin.ModelAdmin):
    list_display = ('image_id', 'image', 'image_date')