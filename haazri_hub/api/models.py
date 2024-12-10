from django.db import models

class AttendanceRecord(models.Model):
    name = models.CharField(max_length=255)  # Name of the attendee
    timestamp = models.DateTimeField(auto_now_add=True)  # Time of attendance

    def __str__(self):
        return f"{self.name} - {self.timestamp}"
