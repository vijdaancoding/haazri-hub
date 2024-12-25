from django.db import models
from django.core.validators import RegexValidator
from datetime import datetime

import uuid

class UploadedImage(models.Model):
    image = models.ImageField(upload_to="uploaded_images/")
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Image {self.id} uploaded at {self.uploaded_at}"
    
class RegisteredStudents(models.Model):

    reg_num = models.CharField(
        max_length=8,
        primary_key=True, 
        unique=True,
        validators=[RegexValidator(regex=r'\d{7,8}$', message="Registration Number must be between 7 and 8 digits.\n")]
    )

    name = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.reg_num
    
class AttendanceRecord(models.Model):

    student = models.ForeignKey(RegisteredStudents, on_delete=models.CASCADE, related_name='attendances') 
    date = models.DateField(default=datetime.now())
    is_present = models.BooleanField(default=False)

    class Meta: 
        unique_together = ('student', 'date')

    def __str__(self):
        return f"{self.student.reg_num} - {self.date} - {'P' if self.is_present else 'A'}"
        
class StoredImages(models.Model):

    image_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    image = models.ImageField(upload_to="uploaded_images/")

    image_date = models.DateTimeField(auto_now_add=True)

    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Image {self.id} stored at {self.image_date}"



